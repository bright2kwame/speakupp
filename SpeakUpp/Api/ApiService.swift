//
//  ApiService.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 05/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import Alamofire
import SwiftyJSON
import RealmSwift
import AWSS3
import AWSCore
import OneSignal



class ApiService {
    let interntConnectionStatus = "Your request failed due to lost of internet connection."
    let failureStatus = "Your request failed, try again later."
    let defaultStatus = "Unable to get requested data, try again later."
    
    //MARK:- set dynamic headers
    func headerAuth() -> [String: String]  {
        let user = User.getUser()!
        let headers = ["Authorization": "Token \(user.token)"]
        return headers
    }
    
    
    //MARK:- register user
    func register(number: String, password:String,username:String,firstName:String,lastName:String,gender:String,birthday:String,completion: @escaping (User?,String,ApiCallStatus) -> ()){
        // this is where the completion handler code goes
        let params = ["phone_number":number,"first_name":firstName,"last_name":lastName,
                      "gender":gender,"birthday":birthday,"username":username,"password":password]
        let url =  "\(ApiUrl().signUp())"
        print("URL \(url) \(params)")
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,headers: nil)
            .responseJSON { response in
                if response.error != nil {
                    completion(nil, self.interntConnectionStatus,.FAILED)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        let item = JSON(data: response.data!)
                        let detail = item["detail"].stringValue
                        if (detail.isEmpty){
                            User.delete()
                            let result = item["results"]
                            let user = self.parseUser(item: result)
                            User.save(data: user)
                            completion(user, "Account created successfully",.SUCCESS)
                        } else {
                            completion(nil, detail,ApiCallStatus.DETAIL)
                        }
                    case 301...499:
                        let item = JSON(data: response.data!)
                        let detail = item["message"].stringValue
                        completion(nil,detail,.DETAIL)
                    default:
                        completion(nil, self.failureStatus,.DETAIL)
                    }
                }
                
        }
    }
    
    
    //MARK:- parse user
    func parseUser(item: JSON) -> User  {
        
        let id = item["id"].intValue.description
        let username = item["username"].stringValue
        let token = item["auth_token"].stringValue
        let phone = item["phone_number"].stringValue
        let gender = item["gender"].stringValue
        var profileUrl = item["avatar"].stringValue
        let firstName = item["first_name"].stringValue
        let lastName = item["last_name"].stringValue
        let isConfirmed = item["is_active"].boolValue
        let birthday = item["birthday"].stringValue
        let bgImage = item["background_image"].stringValue
        let numberOfPolls = item["num_of_polls"].intValue
        let numberOfFollowers = item["num_of_followers"].intValue
        let numberOfFollowing = item["num_of_following"].intValue
        if profileUrl.isEmpty {
           profileUrl = item["sm_avatar"].stringValue
        }
        let userModel = User()
        userModel.profile = profileUrl
        userModel.username = username
        userModel.firstName = firstName
        userModel.lastName = lastName
        userModel.id = id
        userModel.fullName = username
        userModel.number = phone
        userModel.isVerified = isConfirmed
        userModel.token = token
        userModel.birthday = birthday
        userModel.numberOfPolls = numberOfPolls
        userModel.numberOfFollowers = numberOfFollowers
        userModel.numberOfFollowing = numberOfFollowing
        userModel.gender = gender
        userModel.backgroundImage = bgImage
        return userModel
    }
    
    
    //MARK: - verify registration
    func verifyRegisterationCode(uniqueCode: String,completion: @escaping (ApiCallStatus,String) -> ()){
        // this is where the completion handler code goes
        let user = User.getUser()!
        let params = ["unique_code":uniqueCode,"phone_number": user.number]
        let url =  "\(ApiUrl().verify())"
        print("URL \(url) \(params)")
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED,self.interntConnectionStatus)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        //Verified successfully
                        let item = JSON(data: response.data!)
                        let _ = item["detail"].stringValue
                        User.verify()
                        completion(.SUCCESS, "Account verified successfully")
                    case 300...499:
                        //new device
                        let item = JSON(data: response.data!)
                        let detail = item["detail"].stringValue
                        completion(.DETAIL, detail)
                    default:
                        completion(.FAILED, self.failureStatus)
                    }
                }
                
        }
    }
    
    //MARK: - user login
    func login(number: String, pin:String, completion: @escaping (ApiCallStatus,String) -> ()){
        // this is where the completion handler code goes
        let params = ["password":pin,"phone_number":number]
        let url =  "\(ApiUrl().signIn())"
        print("URL \(url) \(params)")
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,headers: nil)
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED,self.interntConnectionStatus)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        //parse user
                        User.delete()
                        let result = JSON(data: response.data!)
                        let user = self.parseUser(item: result["results"])
                        User.save(data: user)
                        completion(.SUCCESS,"Logged in successfully")
                    case 301...499:
                        let item = JSON(data: response.data!)
                        let detail = item["detail"].stringValue
                        completion(.DETAIL, detail)
                    default:
                        completion(.FAILED,self.failureStatus)
                    }
                }
        }
    }
    
    
    typealias StatusMessageCompletionHandler = (_ status:ApiCallStatus,String) -> Void
    
    //MARK: - reset pin
    func initReset(number: String, completion: @escaping (ApiCallStatus,String) -> ()){
        // this is where the completion handler code goes
        let params = ["phone_number":number]
        let url =  "\(ApiUrl().activeBaseUrl())users/reset_password/"
        print("URL \(url) \(params)")
        self.baseApiCall(url: url, params: params, completion: completion)
    }
    
    //MARK: -  confirm reset pin
    func confirmReset(number: String,code:String,completion: @escaping (ApiCallStatus,String) -> ()){
        // this is where the completion handler code goes
        let params = ["phone_number":number,"code":code]
        let url =  "\(ApiUrl().activeBaseUrl())users/reset_password_confirm/"
        print("URL \(url) \(params)")
        self.baseApiCall(url: url, params: params, completion: completion)
    }
    
    //MARK: -  complete reset pin
    func completeReset(number: String,password:String,completion: @escaping (ApiCallStatus,String) -> ()){
        // this is where the completion handler code goes
        let params = ["phone_number":number,"password":password]
        let url =  "\(ApiUrl().activeBaseUrl())users/change_password/"
        print("URL \(url) \(params)")
        self.baseApiCall(url: url, params: params, completion: completion)
    }
    
    
    func baseApiCall(url:String,params: [String:String],completion: @escaping StatusMessageCompletionHandler)  {
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,headers: nil)
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED,self.interntConnectionStatus)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        //parse data
                        let item = JSON(data: response.data!)
                        let detail = item["detail"].stringValue
                        completion(.SUCCESS,detail)
                    case 301...499:
                        let item = JSON(data: response.data!)
                        let detail = item["message"].stringValue
                        completion(.DETAIL, detail)
                    default:
                        completion(.FAILED,self.failureStatus)
                    }
                }
        }
    }
    
 
    
    
    //MARK: - get user
    func getUser(completion: @escaping (ApiCallStatus) -> ()){
        // this is where the completion handler code goes
        let url =  "\(ApiUrl().activeBaseUrl())users/me/"
        print("URL \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        //existing device
                        let result = JSON(data: response.data!)
                        let user = self.parseUser(item: result["results"])
                        User.save(data: user)
                        completion(.SUCCESS)
                    case 301...499:
                        let item = JSON(data: response.data!)
                        let _ = item["detail"].stringValue
                        completion(.DETAIL)
                    default:
                        completion(.FAILED)
                    }
                }
        }
    }
    
    //MARK -- SMS invite
    func inviteViaSMS(number:String,completion: @escaping (ApiCallStatus,String) -> ()){
        // this is where the completion handler code goes
        let realUrl =  "\(ApiUrl().activeBaseUrl())single_send_sms/"
        let params = ["phone_number":number]
        print("URL \(realUrl) \(params)")
        Alamofire.request(realUrl, method: .post, parameters: params, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED,self.interntConnectionStatus)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        let _ = JSON(data: response.data!)
                        completion(.SUCCESS,"Invite sent successfully")
                    case 301...499:
                        let item = JSON(data: response.data!)
                        let detail = item["detail"].stringValue
                        completion(.DETAIL,detail)
                    default:
                        completion(.FAILED,self.failureStatus)
                    }
                }
        }
    }
    
    //MARK -- update user images
    func updateUserProfile(url:String,completion: @escaping (ApiCallStatus,String) -> ()){
        // this is where the completion handler code goes
        let realUrl =  "\(ApiUrl().activeBaseUrl())users/upload_avatar_url/"
        let params = ["avatar":url]
        print("URL \(realUrl) \(params)")
        Alamofire.request(realUrl, method: .post, parameters: params, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED,self.interntConnectionStatus)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        //Profile updated
                        let _ = JSON(data: response.data!)
                        User.updateProfile(avatar: url)
                        completion(.SUCCESS,"Profile updated successfully")
                    case 301...499:
                        let item = JSON(data: response.data!)
                        let detail = item["detail"].stringValue
                        completion(.DETAIL,detail)
                    default:
                        completion(.FAILED,self.failureStatus)
                    }
                }
        }
    }
    
    //MARK -- update user images
    func updateUserBgProfile(url:String,completion: @escaping (ApiCallStatus,String) -> ()){
        // this is where the completion handler code goes
        let realUrl =  "\(ApiUrl().activeBaseUrl())users/update_background_image/"
        let params = ["avatar":url]
        print("URL \(url)")
        Alamofire.request(realUrl, method: .post, parameters: params, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED,self.interntConnectionStatus)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        //existing device
                        let _ = JSON(data: response.data!)
                        User.updateBgProfile(avatar: url)
                        completion(.SUCCESS,"Profile updated successfully")
                    case 301...499:
                        let item = JSON(data: response.data!)
                        let detail = item["detail"].stringValue
                        completion(.DETAIL,detail)
                    default:
                        completion(.FAILED,self.failureStatus)
                    }
                }
        }
    }
  
    //MARK: - update user
    func updateUser(fullName:String,gender:String,dateOfBirth:String,completion: @escaping (ApiCallStatus,String) -> ()){
        // this is where the completion handler code goes
        let url =  "\(ApiUrl().activeBaseUrl())users/me/"
        let user = User.getUser()!
        let params = ["phone_number":user.number,"first_name":"","last_name":"",
                      "gender":gender,"birthday":dateOfBirth,"username":fullName]
        print("URL \(url)")
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED,self.interntConnectionStatus)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        //existing device
                        let result = JSON(data: response.data!)
                        let user = self.parseUser(item: result["results"])
                        User.save(data: user)
                        completion(.SUCCESS,"Profile updated successfully")
                    case 301...499:
                        let item = JSON(data: response.data!)
                        let detail = item["detail"].stringValue
                        completion(.DETAIL,detail)
                    default:
                        completion(.FAILED,self.failureStatus)
                    }
                }
        }
    }
    
    
    //MARK: - resending confirmation code
    func resendVerificationCode(completion: @escaping (ApiCallStatus,String) -> ()){
        // this is where the completion handler code goes
        let number = User.getUser()!.number
        let params = ["phone_number":number]
        let url =  "\(ApiUrl().resendConfirmation())"
        print("URL \(url) \(params)")
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED,self.interntConnectionStatus)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        //code resend initiated successfully
                        if let data =  response.data {
                            let item = JSON(data: data)
                            let results = item["results"].stringValue
                            if (results.isEmpty){
                                completion(.DETAIL, results)
                            }  else {
                                completion(.SUCCESS, results)
                            }
                        } else {
                           completion(.DETAIL, self.defaultStatus)
                        }
                    case 300...499:
                        let item = JSON(data: response.data!)
                        let detail = item["detail"].stringValue
                        completion(.DETAIL, detail)
                    default:
                        completion(.FAILED, self.failureStatus)
                    }
                }
                
        }
    }
    
    //MARK:- all fetch interest
    func allInterest(url:String,completion: @escaping ([PollCategory]?,ApiCallStatus,String?,String?) -> ()){
        // this is where the completion handler code goes
        let url =  "\(ApiUrl().allInterest())"
        print("URL \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        var interests = [PollCategory]()
                        let item = JSON(data: response.data!)
                        let nextUrl = item["next"].stringValue
                        for item in item["results"].enumerated() {
                            let interest = self.parsePollCategory(item: item.element.1)
                            interests.append(interest)
                        }
                        completion(interests, .SUCCESS, nil,nextUrl)
                    case 401...499:
                        completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    default:
                        completion(nil,.FAILED,self.failureStatus,nil)
                    }
                }
                
        }
    }
    
    //MARK:- word cloud
    func workCloud(url:String,completion: @escaping ([UserWorkCloud]?,ApiCallStatus,String?) -> ()){
        // this is where the completion handler code goes
        print("URL \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(nil,.FAILED,self.interntConnectionStatus)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        UserWorkCloud.delete()
                        var clouds = [UserWorkCloud]()
                        if let data =  response.data {
                            let item = JSON(data: data)
                            for itemIn in item["results"].enumerated() {
                                let cloudWork = self.parseWorkCloud(item: itemIn.element.1)
                                UserWorkCloud.save(data: cloudWork)
                                clouds.append(cloudWork)
                            }
                        }
                        completion(clouds, .SUCCESS, nil)
                    case 401...499:
                        completion(nil,.FAILED,self.interntConnectionStatus)
                    default:
                        completion(nil,.FAILED,self.failureStatus)
                    }
                }
                
        }
    }
    
    
    //MARK:- brands
    func brands(url:String,completion: @escaping ([Brand]?,ApiCallStatus,String?,String?) -> ()){
        // this is where the completion handler code goes
        print("URL \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        var brands = [Brand]()
                        var nextUrl = ""
                        if let data =  response.data {
                            let item = JSON(data: data)
                            nextUrl = item["next"].stringValue
                            for itemIn in item["results"].enumerated() {
                                let brand = self.parseBrand(item: itemIn.element.1)
                                brands.append(brand)
                            }
                        }
                        completion(brands, .SUCCESS, nil,nextUrl)
                    case 401...499:
                        completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    default:
                        completion(nil,.FAILED,self.failureStatus,nil)
                    }
                }
                
        }
    }
    

    //MARK:- parse brands
    func parseBrand(item: JSON) -> Brand  {
        let user = self.parsePollAuthour(item: item)
        let isFriend = item["is_friend"].boolValue
        
        let brand = Brand()
        brand.author = user
        brand.id = "\(item["id"].intValue)"
        brand.isFriend = isFriend
        return brand
    }
    
    
    //MARK:- parse user work cloud
    func parseWorkCloud(item: JSON) -> UserWorkCloud  {
        let id = item["myinterest"]["id"].intValue.description
        let name = item["myinterest"]["name"].stringValue
        let cloudValue = item["cloud_value"].doubleValue
        
        let item = UserWorkCloud()
        item.id = id
        item.name = name
        item.cloudValue = cloudValue
        
        return item
    }
    
    
    //MARK:- all polls
    func allPolls(url:String,completion: @escaping ([Poll]?,ApiCallStatus,String?,String?) -> ()){
        print("URL \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in                if response.error != nil {
                    completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        var polls = [Poll]()
                        let item = JSON(data: response.data!)
                        let arrayItems = item["results"]
                        let nextUrl = item["next"].stringValue
                        for itemIn in arrayItems.enumerated() {
                            let pollRetreived = self.parsePoll(item: itemIn.element.1)
                            polls.append(pollRetreived)
                        }
                        completion(polls, .SUCCESS, nil,nextUrl)
                    case 401...499:
                        completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    default:
                        completion(nil,.FAILED,self.failureStatus,nil)
                    }
                }
                
        }
    }
    
    //MARK:- all events
    func allEvents(url:String,completion: @escaping ([Poll]?,ApiCallStatus,String?,String?) -> ()){
        print("URL \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in                if response.error != nil {
                completion(nil,.FAILED,self.interntConnectionStatus,nil)
                return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        var polls = [Poll]()
                        let item = JSON(data: response.data!)
                        let arrayItems = item["results"]
                        let nextUrl = item["next"].stringValue
                        for itemIn in arrayItems.enumerated() {
                            let pollRetreived = self.parsePoll(item: itemIn.element.1)
                            polls.append(pollRetreived)
                        }
                        completion(polls, .SUCCESS, nil,nextUrl)
                    case 401...499:
                        completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    default:
                        completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    }
                }
                
        }
    }
    
    //MARK:- search polls
    func searchPoll(url:String,serchText:String,type:SearchType,completion: @escaping (_ result: [Any]?,_ status: ApiCallStatus,_ message: String?,_ nextUrl: String?) -> ()){
        print("URL \(url)")
        let params = ["search_text":serchText]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        var polls = [Any]()
                        let item = JSON(data: response.data!)
                        let arrayItems = item["results"]
                        let nextUrl = item["next"].stringValue
                        for itemIn in arrayItems.enumerated() {
                            
                            if type == SearchType.poll || type == SearchType.events {
                                let itemRetrieved = self.parsePoll(item: itemIn.element.1)
                                polls.append(itemRetrieved)
                            }
                            if type == SearchType.brands {
                                let itemRetrieved = self.parseBrand(item: itemIn.element.1)
                                polls.append(itemRetrieved)
                            }
                            if type == SearchType.people {
                                let itemRetrieved = self.parsePollAuthour(item: itemIn.element.1)
                                polls.append(itemRetrieved)
                            }
                        }
                        completion(polls, .SUCCESS, nil,nextUrl)
                    case 401...499:
                        completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    default:
                        completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    }
                }
                
        }
    }
    
    //MARK:- all polls in a category
    func allPollsInCategory(url:String,category:String,completion: @escaping ([Poll]?,ApiCallStatus,String?,String?) -> ()){
        print("URL \(url)")
        let params = ["category_id":category]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        var polls = [Poll]()
                        let item = JSON(data: response.data!)
                        let arrayItems = item["results"]
                        let nextUrl = item["next"].stringValue
                        for itemIn in arrayItems.enumerated() {
                            let pollRetreived = self.parsePoll(item: itemIn.element.1)
                            polls.append(pollRetreived)
                        }
                        completion(polls, .SUCCESS, nil,nextUrl)
                    case 401...499:
                        completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    default:
                        completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    }
                }
                
        }
    }
    
    //MARK:- all trends
    func allPollsTrends(url:String,completion: @escaping ([TrendingMenuLabel]?,ApiCallStatus,String?,String?) -> ()){
        print("URL \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in                if response.error != nil {
                completion(nil,.FAILED,self.interntConnectionStatus,nil)
                return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        var labels = [TrendingMenuLabel]()
                        let item = JSON(data: response.data!)
                        let arrayItems = item["results"]
                        let nextUrl = item["next"].stringValue
                        for itemIn in arrayItems.enumerated() {
                            let retreived = self.parseTrendingCategoryItem(item: itemIn.element.1)
                            labels.append(retreived)
                        }
                        completion(labels, .SUCCESS, nil,nextUrl)
                    case 401...499:
                        completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    default:
                        completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    }
                }
                
        }
    }
    
    
    
    //MARK:- all schools
    func allNews(url:String,completion: @escaping ([NewsItem]?,ApiCallStatus,String?,String?) -> ()){
        print("URL \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in                if response.error != nil {
                completion(nil,.FAILED,self.interntConnectionStatus,nil)
                return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        var labels = [NewsItem]()
                        let item = JSON(data: response.data!)
                        print("ITEM \(item)")
                        let arrayItems = item["results"]
                        let nextUrl = item["next"].stringValue
                        for itemIn in arrayItems.enumerated() {
                            let retreived = self.parseNewsItem(item: itemIn.element.1)
                            labels.append(retreived)
                        }
                        completion(labels, .SUCCESS, nil,nextUrl)
                    case 401...499:
                        completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    default:
                        completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    }
                }
                
        }
    }
    
    //MARK:- all corporate groups
    func allCorporateGroups(url:String,completion: @escaping ([CorporateItem]?,ApiCallStatus,String?,String?) -> ()){
        print("URL \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in                if response.error != nil {
                completion(nil,.FAILED,self.interntConnectionStatus,nil)
                return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        var labels = [CorporateItem]()
                        let item = JSON(data: response.data!)
                        let arrayItems = item["results"]
                        let nextUrl = item["next"].stringValue
                        for itemIn in arrayItems.enumerated() {
                            let retreived = self.parseCorporateItem(item: itemIn.element.1)
                            labels.append(retreived)
                        }
                        completion(labels, .SUCCESS, nil,nextUrl)
                    case 401...499:
                        completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    default:
                        completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    }
                }
                
        }
    }
    
    //MARK:- all trending catergory
    func allPollsCategory(url:String,completion: @escaping ([TrendingMenuLabel]?,ApiCallStatus,String?,String?) -> ()){
        print("URL \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in                if response.error != nil {
                completion(nil,.FAILED,self.interntConnectionStatus,nil)
                return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        var labels = [TrendingMenuLabel]()
                        let item = JSON(data: response.data!)
                        let arrayItems = item["results"]
                        let nextUrl = item["next"].stringValue
                        for itemIn in arrayItems.enumerated() {
                            let retreived = self.parseTrendingCategoryItem(item: itemIn.element.1)
                            labels.append(retreived)
                        }
                        completion(labels, .SUCCESS, nil,nextUrl)
                    case 401...499:
                        completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    default:
                        completion(nil,.FAILED,self.interntConnectionStatus,nil)
                    }
                }
                
        }
    }
    
    //MARK: - parse corporate itme
    func parseCorporateItem(item: JSON) -> CorporateItem  {
        let id = item["id"].intValue.description
        let name = item["name"].stringValue
        let image = item["image"].stringValue
        let item = CorporateItem()
        item.image = image
        item.id = id
        item.name = name
        return item
    }
    
    //MARK: - parse school item
    func parseSchoolItem(item: JSON) -> SchoolItem  {
        let id = item["id"].intValue.description
        let name = item["name"].stringValue
        let image = item["image"].stringValue
        let item = SchoolItem()
        item.image = image
        item.id = id
        item.name = name
        return item
    }
    
    //MARK: - parse news item
    func parseNewsItem(item: JSON) -> NewsItem  {
        print("NEWS \(item)")
        let id = item["id"].intValue.description
        let name = item["title"].stringValue
        let image = item["image"].stringValue
        let content = item["content"].stringValue
        _ = item["has_liked"].boolValue
        _ = item["num_of_comments"].intValue
        _ = item["num_of_likes"].intValue
        
        let item = NewsItem()
        item.image = image
        item.content = content
        item.title = name
        item.id = id
        return item
    }
    
    //MARK: - parse poll category
    func parseTrendingCategoryItem(item: JSON) -> TrendingMenuLabel  {
        let id = item["id"].intValue.description
        let name = item["name"].stringValue
        return TrendingMenuLabel(title: name, id: id)
    }
    
    //MARK:- parse poll
    func parsePoll(item: JSON) -> Poll  {
        let id = item["id"].intValue.description
        let totalVotes = item["total_votes"].intValue
        let totalRatingVotes = item["total_rating_votes"].intValue
        let eventTitle = item["event_title"].stringValue
        let eventTime = item["event_time"].stringValue
        let eventStartDate = item["event_start_date"].stringValue
        let eventEndDate = item["event_end_date"].stringValue
        let eventLocation = item["event_location"].stringValue
        let ratingOption = item["rating_option"].stringValue
        let pricePerSMS = item["price_per_sms"].stringValue
        let price = item["price"].stringValue
        let author = self.parsePollAuthour(item: item["author"])
        let isAudio = item["is_audio"].boolValue
        let hasExpired = item["has_expired"].boolValue
        let hasImages = item["has_images"].boolValue
        let isBinary = item["is_binary"].boolValue
        let _ = item["has_link"].boolValue
        let hasLiked = item["has_liked"].boolValue
        let hasVoted = item["has_voted"].boolValue
        let isShared = item["is_shared"].boolValue
        let hasTicket = item["has_ticket"].boolValue
        let hasPurchased = item["has_purchased"].boolValue
        let category = self.parsePollCategory(item: item["category"])
        let pollType = item["poll_type"].stringValue
        let eventDescription = item["event_description"].stringValue
        let latitude = item["latitude"].stringValue
        let image = item["image"].stringValue
        let expiryDate = item["expiry_date"].stringValue
        let longitude = item["longitude"].stringValue
        let resultsVisibility = item["results_visibility"].stringValue
        let numOfComments = item["num_of_comments"].intValue
        let numOfLikes = item["num_of_likes"].intValue
        let numOfShares = item["num_of_shares"].intValue
        let totalAverageRating = item["total_average_rating"].intValue
        let _ = item["voted_option"].stringValue
        let question = item["question"].stringValue
        let audio = item["audio"].stringValue
        let shortCode = item["short_code"].stringValue
        let elapsedTime = item["elapsed_time"].stringValue
        let votedOption = item["voted_option"].stringValue
        
        let poll = Poll()
        poll.id = id
        poll.audio = audio
        poll.eventDescription = eventDescription
        poll.eventTitle = eventTitle
        poll.eventTime = eventTime
        poll.eventStartDate  = eventStartDate
        poll.eventEndDate = eventEndDate
        poll.eventLocation = eventLocation
        poll.author = author
        poll.category = category
        poll.ratingOptions = ratingOption
        poll.pricePerSMS = pricePerSMS
        poll.isAudio = isAudio
        poll.hasLiked = hasLiked
        poll.hasExpired = hasExpired
        poll.hasImages = hasImages
        poll.isShared = isShared
        poll.isBinary = isBinary
        poll.hasVoted = hasVoted
        poll.totalVotes = totalVotes
        poll.totalRatingVotes = totalRatingVotes
        poll.numOfLikes = numOfLikes
        poll.numOfShares = numOfShares
        poll.numOfComments = numOfComments
        poll.totalAverageRating = totalAverageRating
        poll.expiryDate = expiryDate
        poll.pollType = pollType
        poll.image = image
        poll.longitude = longitude
        poll.latitude = latitude
        poll.resultVisibity = resultsVisibility
        poll.shortCode = shortCode
        poll.elapsedTime = elapsedTime
        poll.question = question
        poll.price = price
        poll.hasTicket = hasTicket
        poll.hasPurchased = hasPurchased
        poll.votedOption = votedOption
        
        let pollChoices = List<PollChoice>()
        for pollChoice in item["poll_choices"].arrayValue {
            pollChoices.append(self.parsePollChoice(item: pollChoice,poll: poll))
        }
        
        let pollParams = List<PollOption>()
        for pollParam in item["parameters"].arrayValue {
            pollParams.append(self.parsePollParameter(item: pollParam, poll: poll))
        }
        poll.pollChoice = pollChoices
        poll.vottingOptions = pollParams
        return poll
    }
    
    
    //MARK: poll choices
    func parsePollChoice(item: JSON,poll: Poll) -> PollChoice  {
        let id = item["id"].intValue.description
        let shortCodeText = item["short_code_text"].stringValue
        let resultPercent = item["result_percent"].stringValue
        let choiceText = item["choice_text"].stringValue
        let numOfVotes = item["num_of_votes"].intValue
        let image = item["image"].stringValue
        let description = item["description"].stringValue
        let audio = item["audio"].stringValue
        
        let itemParsed = PollChoice()
        itemParsed.poll = poll
        itemParsed.id = id
        itemParsed.choiceText = choiceText
        itemParsed.resultPercent = resultPercent
        itemParsed.shortCodeText = shortCodeText
        itemParsed.numOfVotes = numOfVotes
        itemParsed.image = image
        itemParsed.choiceDescription = description
        itemParsed.audio = audio
        itemParsed.isSelectedOption = poll.votedOption == id
        return itemParsed
    }
    
    //MARK: poll parameters
    func parsePollParameter(item: JSON, poll: Poll) -> PollOption  {
        let id = item["id"].intValue.description
        let name = item["name"].stringValue
        let image = item["image"].stringValue
        let itemParsed = PollOption()
        itemParsed.id = id
        itemParsed.name = name
        itemParsed.imageUrl = image
        itemParsed.poll = poll
        return itemParsed
    }
    
    
    
    //MARK - parse comment
    func parsePollComment(item: JSON) -> PollComment  {
        let id = item["id"].intValue.description
        let comment = item["comment"].stringValue
        let elapsedTime = item["elapsed_time"].stringValue
        let author = self.parsePollAuthour(item: item["author"])

        let itemParsed = PollComment()
        itemParsed.id = id
        itemParsed.author = author
        itemParsed.comment = comment
        itemParsed.elapedTime = elapsedTime
        return itemParsed
    }
    
    func parsePollCategory(item: JSON) -> PollCategory  {
        let id = item["id"].intValue.description
        let totalPolls = item["total_polls"].intValue
        let name = item["name"].stringValue
        let image = item["image"].stringValue
        let hexCode = item["hex_code"].stringValue
        
        let itemParsed = PollCategory()
        itemParsed.id = id
        itemParsed.name = name
        itemParsed.imageUrl = image
        itemParsed.totalPolls = totalPolls
        itemParsed.hexValue = hexCode
        return itemParsed
    }
    
    
    //MARK - parse poll author
    func parsePollAuthour(item: JSON) -> PollAuthor  {
        let id = item["id"].intValue.description
        var avatarThumb = item["avatar_thumb"].stringValue
        let brandName = item["brand_name"].stringValue
        let avatar = item["avatar"].stringValue
        let firstName = item["first_name"].stringValue
        let birthday = item["birthday"].stringValue
        let username = item["username"].stringValue
        let lastName = item["last_name"].stringValue
        let country = item["country"].stringValue
        let smAvatar = item["sm_avatar"].stringValue
        if avatarThumb.isEmpty {
            avatarThumb = smAvatar
        }
        
        let itemParsed = PollAuthor()
        itemParsed.id = id
        itemParsed.avatar = avatarThumb
        itemParsed.profile = avatar
        itemParsed.brandName = brandName
        itemParsed.firstName = firstName
        itemParsed.lastName = lastName
        itemParsed.country = country
        itemParsed.birthday = birthday
        itemParsed.username = username
        return itemParsed
    }
    
    
    //MARK -- parse the event ticket
    func parsePollTicket(item: JSON) -> EventTicket  {
        let id = item["id"].intValue.description
        let quantity = item["quantity"].intValue
        let totalAmount = item["total_amount"].stringValue
        let date = item["date_redeemed"].stringValue
        let orderNumber = item["order_number"].stringValue
        let isUsed = item["is_used"].boolValue
        
        let author = self.parsePollAuthour(item: item["author"])
        let poll = self.parsePoll(item: item["poll"])
        let itemParsed = EventTicket()
        itemParsed.id = id
        itemParsed.author = author
        itemParsed.poll = poll
        itemParsed.isUsed = isUsed
        itemParsed.quantity = quantity
        itemParsed.totalAmount = totalAmount
        itemParsed.dateRedeemed = date
        itemParsed.orderNumber = orderNumber
  
        return itemParsed
    }
    
    
    //MARK: - resending confirmation code
    func getCurrentVersion(completion: @escaping (ApiCallStatus,String) -> ()){
        // this is where the completion handler code goes
        let url =  "\(ApiUrl().activeBaseUrl())check_ios_version/"
        print("URL \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED,self.failureStatus)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        if let dataIn =  response.data {
                            let item = JSON(data: dataIn)
                            let detail = item["app_version"].stringValue
                            completion(.SUCCESS,detail)
                        } else {
                            completion(.DETAIL,"Unable to cast vote")
                        }
                    case 300...499:
                        completion(.DETAIL,self.defaultStatus)
                    default:
                        completion(.FAILED,self.failureStatus)
                    }
                }
                
        }
    }
    
    //MARK: - resending confirmation code
    func applePayStatus(completion: @escaping (ApiCallStatus,String) -> ()){
        // this is where the completion handler code goes
        let url =  "\(ApiUrl().activeBaseUrl())turn_off_apple_pay/"
        print("URL \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED,self.failureStatus)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        if let dataIn =  response.data {
                            let item = JSON(data: dataIn).boolValue
                            UserDefaults.standard.set(item, forKey: "APPLE_PAY_STATUS")
                            completion(.SUCCESS,"SUCCESS")
                        }
                        completion(.DETAIL,"DONE")
                    case 300...499:
                        completion(.DETAIL,self.defaultStatus)
                    default:
                        completion(.FAILED,self.failureStatus)
                    }
                }
                
        }
    }
    
    //MARK: - resending confirmation code
    func ratePoll(pollId: String,ratingValue:String,completion: @escaping (ApiCallStatus,String) -> ()){
        // this is where the completion handler code goes
        let params = ["rating_value":ratingValue,"device_model": UIDevice.current.modelName]
        let url =  "\(ApiUrl().activeBaseUrl())polls/\(pollId)/rate/"
        print("URL \(url) \(params)")
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED,self.failureStatus)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        if let dataIn =  response.data {
                            let item = JSON(data: dataIn)
                            var detail = item["detail"].stringValue
                            if detail.isEmpty {
                                 let _ = self.parsePoll(item: item["results"])
                                detail = "Rated successfuly"
                            }
                            completion(.SUCCESS,detail)
                        } else {
                            completion(.DETAIL,"Unable to cast vote")
                        }
                    case 300...499:
                        completion(.DETAIL,self.defaultStatus)
                    default:
                        completion(.FAILED,self.failureStatus)
                    }
                }
                
        }
    }
        
    //MARK: - resending confirmation code
    func voteForPoll(pollId: String,choiceId:String,completion: @escaping (ApiCallStatus,String) -> ()){
        // this is where the completion handler code goes
        let params = ["choice_id":choiceId,"device_model": UIDevice.current.modelName]
        let url =  "\(ApiUrl().activeBaseUrl())polls/\(pollId)/vote/"
        print("URL \(url) \(params)")
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED,self.failureStatus)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        if let dataIn =  response.data {
                            let item = JSON(data: dataIn)
                            var detail = item["detail"].stringValue
                            if detail.isEmpty {
                               let _ = self.parsePoll(item: item["results"])
                               detail = "Vote casted successfuly"
                            }
                            completion(.SUCCESS,detail)
                        } else {
                            completion(.DETAIL,"Unable to cast vote")
                        }
                    case 301...499:
                        completion(.DETAIL,self.defaultStatus)
                    default:
                        completion(.FAILED,self.failureStatus)
                    }
                }
                
        }
    }
    
    
    typealias CompletionHandler = (_ status:ApiCallStatus) -> Void
    
    //MARK: - unfollow user
    func unFollowUser(otherUserId: String, completion: @escaping (ApiCallStatus) -> ()){
        let userId = User.getUser()!.id
        let url =  "\(ApiUrl().unfollowUser(userId: userId))"
        self.baseFollowUser(otherUserId: otherUserId, url: url, completion: completion)
    }
    
    //MARK: - follow user
    func followUser(otherUserId: String, completion: @escaping (ApiCallStatus) -> ()){
        let userId = User.getUser()!.id
        let url =  "\(ApiUrl().followUser(userId: userId))"
        self.baseFollowUser(otherUserId: otherUserId, url: url, completion: completion)
    }
    
    //MARK: - base follow user
    func baseFollowUser(otherUserId: String,url:String, completion: @escaping CompletionHandler){
        // this is where the completion handler code goes
        let params = ["user_id":otherUserId]
        print("URL \(url) \(params)")
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        if let _ =  response.data {
                            completion(.SUCCESS)
                        } else {
                            completion(.DETAIL)
                        }
                    case 300...499:
                        completion(.DETAIL)
                    default:
                        completion(.FAILED)
                    }
                }
                
        }
    }
    
    //MARK: - like poll
    func likePoll(pollId: String, completion: @escaping (ApiCallStatus) -> ()){
        let url =  "\(ApiUrl().activeBaseUrl())polls/\(pollId)/like/"
        self.baseLikingAction(url: url, completion: completion)
    }
    
    //MARK: - unlike  poll
    func unLikePoll(pollId: String, completion: @escaping (ApiCallStatus) -> ()){
        let url =  "\(ApiUrl().activeBaseUrl())polls/\(pollId)/unlike/"
        self.baseLikingAction(url: url, completion: completion)
    }
    
    //MARK: - base liking action
    func baseLikingAction(url:String, completion: @escaping CompletionHandler){
        // this is where the completion handler code goes
        print("URL \(url)")
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        if let _ =  response.data {
                            completion(.SUCCESS)
                        } else {
                            completion(.DETAIL)
                        }
                    case 300...499:
                        completion(.DETAIL)
                    default:
                        completion(.FAILED)
                    }
                }
                
        }
    }
    
    
    //MARK: - Paid votting
    func makeApplePayment(url: String,params:[String:Any],completion: @escaping (ApiCallStatus,String?) -> ()){
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED,nil)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...204:
                        completion(.SUCCESS,"Payment received successfully.")
                    case 300...499:
                        completion(.DETAIL,nil)
                    default:
                        completion(.FAILED,nil)
                    }
                }
        }
    }

    //MARK: - Paid votting
    func payForVote(url: String,params:[String:Any],completion: @escaping (ApiCallStatus,String?) -> ()){
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED,nil)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        if let dataIn =  response.data {
                            let item = JSON(data: dataIn)
                            let url = item["redirect_url"].stringValue
                            completion(.SUCCESS,url)
                        } else {
                            completion(.DETAIL,nil)
                        }
                    case 300...499:
                        completion(.DETAIL,nil)
                    default:
                        completion(.FAILED,nil)
                    }
                }
        }
    }
    
    //MARK: - Buy ticket
    func buyTicket(pollId: String,quantity:String,completion: @escaping (ApiCallStatus,String?) -> ()){
        let params = ["event_id":pollId,"quantity":quantity]
        let url =  "\(ApiUrl().activeBaseUrl())get_slydepay_url/"
        print("URL \(url) \(params)")
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED,nil)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        if let dataIn =  response.data {
                            let item = JSON(data: dataIn)
                            let redirect = item["redirect_url"].stringValue
                            completion(.SUCCESS,redirect)
                        } else {
                            completion(.DETAIL,nil)
                        }
                    case 300...499:
                        completion(.DETAIL,nil)
                    default:
                        completion(.FAILED,nil)
                    }
                }
        }
    }

    //MARK: - get poll
    func getPoll(pollId:String,completion: @escaping (ApiCallStatus,Poll?,String?) -> ()){
        // this is where the completion handler code goes
        let url =  "\(ApiUrl().activeBaseUrl())polls/\(pollId)/"
        print("URL \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED,nil,self.interntConnectionStatus)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        //existing device
                        let result = JSON(data: response.data!)
                        let poll = self.parsePoll(item: result["results"])
                        completion(.SUCCESS,poll,nil)
                    case 301...499:
                        let item = JSON(data: response.data!)
                        let detail = item["detail"].stringValue
                        completion(.DETAIL,nil,detail)
                    default:
                        completion(.FAILED,nil,self.interntConnectionStatus)
                    }
                }
        }
    }
    
    //MARK: - get ticket
    func getEventTicket(pollId:String,completion: @escaping (ApiCallStatus,EventTicket?,String?) -> ()){
        // this is where the completion handler code goes
        let url =  "\(ApiUrl().activeBaseUrl())events/\(pollId)/get_receipt/"
        print("URL \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED,nil,self.interntConnectionStatus)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        //tcket in now
                        let item = JSON(data: response.data!)
                        let arrayItems = item["results"]
                        for itemIn in arrayItems.enumerated() {
                            let retreived = self.parsePollTicket(item: itemIn.element.1)
                            completion(.SUCCESS,retreived,nil)
                            break
                        }
                        completion(.DETAIL,nil,"Ticket used by another person.")
                    case 301...499:
                        let item = JSON(data: response.data!)
                        let detail = item["detail"].stringValue
                        completion(.DETAIL,nil,detail)
                    default:
                        completion(.FAILED,nil,self.interntConnectionStatus)
                    }
                }
        }
    }
    
    
    //MARK: - cancel ticket
    func cancelTicket(orderNumber:String,completion: @escaping (ApiCallStatus,String) -> ()){
        let params = ["ticket_code":orderNumber]
        let url =  "\(ApiUrl().activeBaseUrl())cancel_ticket/"
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED,self.interntConnectionStatus)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        //ticket operation
                        let result = JSON(data: response.data!)
                        let detail = result["detail"].stringValue
                        if !detail.isEmpty {
                           completion(.DETAIL,detail)
                        }
                        let resultInfo = result["results"].stringValue
                        let quantity = result["quantity"].intValue
                        let message = "\(resultInfo) Quantity: \(quantity)"
                        completion(.SUCCESS, message)
                    case 301...499:
                        let item = JSON(data: response.data!)
                        let detail = item["detail"].stringValue
                        completion(.DETAIL,detail)
                    default:
                        completion(.FAILED,self.interntConnectionStatus)
                    }
                }
        }
    }
    
    //MARK: - get poll comment
    func getPollComments(url:String,completion: @escaping (ApiCallStatus,[PollComment]?,String?,String?) -> ()){
        // this is where the completion handler code goes
        print("URL \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED,nil,self.interntConnectionStatus,nil)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        //existing device
                        var comments = [PollComment]()
                        let item = JSON(data: response.data!)
                        let arrayItems = item["results"]
                        let nextUrl = item["next"].stringValue
                        for itemIn in arrayItems.enumerated() {
                            let retreived = self.parsePollComment(item: itemIn.element.1)
                            comments.append(retreived)
                        }
                        completion(.SUCCESS, comments, "Data retrieved successfully", nextUrl)
                    case 301...499:
                        let item = JSON(data: response.data!)
                        let detail = item["detail"].stringValue
                        completion(.DETAIL,nil,detail,nil)
                    default:
                        completion(.FAILED,nil,self.interntConnectionStatus,nil)
                    }
                }
        }
    }
    
    //MARK: - Add Comment
    func commentOnPoll(pollId: String,comment:String,completion: @escaping (ApiCallStatus,PollComment?,String?) -> ()){
        let params = ["user_comment":comment]
        let url =  "\(ApiUrl().activeBaseUrl())polls/\(pollId)/comment/"
        print("URL \(url) \(params)")
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED,nil,self.interntConnectionStatus)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        if let dataIn =  response.data {
                            let item = JSON(data: dataIn)
                            let comment = self.parsePollComment(item: item["detail"])
                            completion(.SUCCESS,comment,item["message"].stringValue)
                        } else {
                            completion(.DETAIL,nil,"")
                        }
                    case 300...499:
                        let item = JSON(data: response.data!)
                        let detail = item["detail"].stringValue
                        completion(.DETAIL,nil,detail)
                    default:
                        completion(.FAILED,nil,self.interntConnectionStatus)
                    }
                }
        }
    }
    
    //MARK: - update user interests
    func updateUserInterest(ids: String, completion: @escaping (ApiCallStatus) -> ()){
        // this is where the completion handler code goes
        let params = ["interest_ids":ids]
        let userId = User.getUser()!.id
        let url =  "\(ApiUrl().updateInterest(userId: userId))"
        print("URL \(url) \(params)")
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        if let _ =  response.data {
                            completion(.SUCCESS)
                        } else {
                            completion(.DETAIL)
                        }
                    case 300...499:
                        completion(.DETAIL)
                    default:
                        completion(.FAILED)
                    }
                }
        }
    }
    
    //MARK: - update user interests
    func saveCredentials(completion: @escaping (ApiCallStatus) -> ()){
        let url =  "\(ApiUrl().credentails())"
        print("URL \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        if let dataIn =  response.data {
                            let item = JSON(data: dataIn)
                            AWSCredentails.delete()
                            let credentials = self.parseCredentail(item: item)
                            AWSCredentails.save(data: credentials)
                            completion(.SUCCESS)
                        } else {
                            completion(.DETAIL)
                        }
                    case 300...499:
                        completion(.DETAIL)
                    default:
                        completion(.FAILED)
                    }
                }
        }
    }
    
    //MARK:- data. FAQ, PRIVACY, ETC
    func getMessages(url:String,completion: @escaping (String?,ApiCallStatus,String?) -> ()){
        let realUrl = "\(ApiUrl().activeBaseUrl())\(url)/"
        print("URL \(realUrl)")
        Alamofire.request(realUrl, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: nil)
            .responseJSON { response in
                if response.error != nil {
                 completion(nil,.FAILED,self.interntConnectionStatus)
                 return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        var content = ""
                        let item = JSON(data: response.data!)
                        let results = item["results"]
                        for itemIn in results.enumerated() {
                            content = itemIn.element.1["content"].stringValue
                        }
                        completion(content, .SUCCESS, nil)
                    case 401...499:
                        completion(nil,.FAILED,self.interntConnectionStatus)
                    default:
                        completion(nil,.FAILED,self.interntConnectionStatus)
                    }
                }
                
        }
    }
    
    //MARK:- data. FAQ, PRIVACY, ETC
    func getFaqMessages(url:String,completion: @escaping ([FAQItem]?,ApiCallStatus,String?) -> ()){
        let realUrl = "\(ApiUrl().activeBaseUrl())\(url)/"
        print("URL \(realUrl)")
        Alamofire.request(realUrl, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(nil,.FAILED,self.interntConnectionStatus)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        var content = [FAQItem]()
                        let item = JSON(data: response.data!)
                        let results = item["results"]
                        for itemIn in results.enumerated() {
                            let question = itemIn.element.1["question"].stringValue.htmlToString
                            let answer = itemIn.element.1["answer"].stringValue.htmlToString
                            content.append(FAQItem(question: question, answer: answer))
                        }
                        completion(content, .SUCCESS, nil)
                    case 401...499:
                        completion(nil,.FAILED,self.interntConnectionStatus)
                    default:
                        completion(nil,.FAILED,self.interntConnectionStatus)
                    }
                }
                
        }
    }
    
    func parseCredentail(item: JSON) -> AWSCredentails  {
        let AWS_ACCESS_KEY_ID = item["AWS_ACCESS_KEY_ID"].stringValue
        let AWS_BUCKET_NAME = item["AWS_BUCKET_NAME"].stringValue
        let AWS_BUCKET_REGION = item["AWS_BUCKET_REGION"].stringValue
        let AWS_SECRET_ACCESS_KEY = item["AWS_SECRET_ACCESS_KEY"].stringValue
        
        let itemParsed = AWSCredentails()
        itemParsed.accessKey = AWS_ACCESS_KEY_ID
        itemParsed.secretKey = AWS_SECRET_ACCESS_KEY
        itemParsed.bucketName = AWS_BUCKET_NAME
        itemParsed.region = AWS_BUCKET_REGION
        return itemParsed
    }
    
    func getRemoteName(nameOfFolder:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = Date()
        dateFormatter.string(from: date)
        var newPath =  String(describing: date).replacingOccurrences(of: "-", with: "/", options: .literal, range: nil).replacingOccurrences(of: " ", with: "/", options: .literal, range: nil).replacingOccurrences(of: ":", with: "/", options: .literal, range: nil)
        
        newPath = newPath.components(separatedBy: "+")[0] + NSUUID().uuidString
        let remoteName = "\(nameOfFolder)/\(newPath).jpeg"
        return remoteName
        
    }
    
    func getImage(image:UIImage) -> NSURL  {
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(NSUUID().uuidString).jpeg")
        let imageData = UIImageJPEGRepresentation(image, 0.99)
        fileManager.createFile(atPath: path as String, contents: imageData, attributes: nil)
        return NSURL(fileURLWithPath: path)
    }
    
    
    
    func startUpload(file:UIImage,nameOfFolder:String,completion: @escaping (ApiCallStatus,String?,String?) -> ()) {
        let url = getImage(image: file)
        if let awsCredentials = AWSCredentails.getUser() {
            let remoteName = self.getRemoteName(nameOfFolder: nameOfFolder)
            let S3BucketName = awsCredentials.bucketName
            let uploadRequest = AWSS3TransferManagerUploadRequest()!
            uploadRequest.body = url as URL
            uploadRequest.key = remoteName
            uploadRequest.bucket = S3BucketName
            uploadRequest.contentType = "image/jpeg"
            uploadRequest.acl = .publicRead
            
            let credentialsProvider = AWSStaticCredentialsProvider(accessKey: awsCredentials.accessKey, secretKey: awsCredentials.secretKey)
            let configuration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
            AWSServiceManager.default().defaultServiceConfiguration = configuration
            
            let transferManager = AWSS3TransferManager.default()
            transferManager.upload(uploadRequest).continueWith { (task) -> AnyObject! in
                let message = "Upload failed unexpectedly"
                if let error = task.error {
                    let message = "Upload failed  (\(error))"
                    completion(.FAILED, nil, message)
                }
                if task.result != nil {
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!)
                    if let realUrl = publicURL?.absoluteString {
                        completion(.SUCCESS, realUrl, "File uploaded successfully")
                    } else {
                        completion(.DETAIL, nil, message)
                    }
                } else {
                    completion(.FAILED, nil, message)
                }
                return nil
            }
        } else {
            completion(.DETAIL, nil, "AWS Credentails not provided")
        }
        
    }
    
    //MARK: - update user token
    func updateUserToken(completion: @escaping (ApiCallStatus) -> ()){
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let userID = status.subscriptionStatus.userId
        guard let playerId = userID else {return}
        let params = ["player_id":playerId]
        let url =  "\(ApiUrl().activeBaseUrl())users/save_player_id/"
        print("URL \(url) \(params)")
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,headers: headerAuth())
            .responseJSON { response in
                if response.error != nil {
                    completion(.FAILED)
                    return
                }
                if let status = response.response?.statusCode {
                    print("Status \(status)")
                    switch(status){
                    case 200...300:
                        if let _ =  response.data {
                            completion(.SUCCESS)
                        } else {
                            completion(.DETAIL)
                        }
                    case 300...499:
                        completion(.DETAIL)
                    default:
                        completion(.FAILED)
                    }
                }
        }
    }


}
