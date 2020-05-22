//
//  ApiUrl.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 05/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import Foundation

class ApiUrl {
    let baseUrl = "https://www.speakupp.com/api/v1.0/"
    let register = "users/signup/"
    let confirm = "users/signup_confirm/"
    let login = "users/mobile_login/"
    let resendCode = "resend_verification_code/"
    let interest = "fetch_interest/"
    let updateInterest = "update_user_interest/"
    let brands = "get_brands/"
    let pollsUrl = "polls/"
    let allPollsUrl = "new_polls/"
    let allOnlyPollsUrl = "mobile/new_all_polls/"
    let allRatingPollsUrl = "mobile/all_ratings/"
    let allEventsUrl = "mobile/all_events/"
    let trendingCategory = "polls/trending/"
    let allTrending = "polls/all_trending_polls/"
    let allTrendingDetail = "polls/trending_detail/"
    let authToken = "9083589085398983053850348053"
    let callBackUrl = "https://www.speakupp.com/slydepay_callback/"
    let paymentCallBackUrl = "https://www.speakupp.com/quiz_pay/"
    
    func activeBaseUrl() -> String {
        return "\(baseUrl)"
    }
    
    func signUp() -> String {
      return "\(activeBaseUrl())\(register)"
    }
    
    func verify() -> String {
        return "\(activeBaseUrl())\(confirm)"
    }
    
    func signIn() -> String {
        return "\(activeBaseUrl())\(login)"
    }
    
    func resendConfirmation() -> String {
        return "\(activeBaseUrl())\(resendCode)"
    }
    
    func allInterest() -> String {
        return "\(activeBaseUrl())\(interest)"
    }
    
    
    func updateInterest(userId:String) -> String {
        return "\(activeBaseUrl())users/\(userId)/\(updateInterest)"
    }
    
    func followUser(userId:String) -> String {
        return "\(activeBaseUrl())users/\(userId)/follow/"
    }
    
    func unfollowUser(userId:String) -> String {
        return "\(activeBaseUrl())users/\(userId)/follow/"
    }
    
    func allBrands() -> String {
        return "\(activeBaseUrl())\(brands)"
    }
    
    func allPolls() -> String {
        return "\(activeBaseUrl())\(pollsUrl)"
    }
    
    func allNewPolls() -> String {
        return "\(activeBaseUrl())\(allPollsUrl)"
    }
    
    func allOnlyPolls() -> String {
        return "\(activeBaseUrl())\(allOnlyPollsUrl)"
    }

    func allRatingPolls() -> String {
        return "\(activeBaseUrl())\(allRatingPollsUrl)"
    }
    
    func allTrendingCategory() -> String {
        return "\(activeBaseUrl())\(trendingCategory)"
    }
    
    func allTrendings() -> String {
        return "\(activeBaseUrl())\(allTrending)"
    }
    
    func allTrendingDeatails() -> String {
        return "\(activeBaseUrl())\(allTrendingDetail)"
    }
    
    func allEvents() -> String {
        return "\(activeBaseUrl())\(allEventsUrl)"
    }
    
    func credentails() -> String {
        return "\(activeBaseUrl())get_credentials/"
    }
    
    func corporate() -> String {
        return "\(activeBaseUrl())all_new_polls/"
    }
    
    func shools() -> String {
        return "\(activeBaseUrl())school_groupings/"
    }
    
    func news() -> String {
        return "\(activeBaseUrl())news/"
    }
    
    func timeline() -> String {
        return "\(activeBaseUrl())timeline/"
    }
    
    func callBack() -> String {
        return "\(callBackUrl)"
    }
    
    func speakUppCallBack() -> String {
        return "\(paymentCallBackUrl)"
    }
    
    func leaderBoard() -> String {
       return "\(activeBaseUrl())new_leaderboard/"
    }
    
    func partners() -> String {
       return "\(activeBaseUrl())partners/"
    }
    
    func quizes() -> String {
        return "\(activeBaseUrl())quizzes/"
    }
    
}
