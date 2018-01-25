//
//  User.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 22/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import RealmSwift

class User: Object {
    @objc dynamic var id = ""
    @objc dynamic var token = ""
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var number = ""
    @objc dynamic var fullName = ""
    @objc dynamic var email = ""
    @objc dynamic var profile = ""
    @objc dynamic var dob = ""
    @objc dynamic var lastLogin = ""
    @objc dynamic var deviceInfo = ""
    @objc dynamic var pin = ""
    @objc dynamic var isVerified = false
    

    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    
    //get user saved into the db
    static func getUser() -> User?{
        let realm = try! Realm()
        let user = realm.objects(User.self).first
        return user
    }
    
    //save user
    static func save(data: User) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(data,update: true)
        }
    }
    
    //update user to status of being verified
    static func verify() {
        let realm = try! Realm()
        let data = getUser()!
        try! realm.write() {
            data.isVerified = true
            realm.add(data,update: true)
        }
    }
    
    static func updateProfileDetail(data: User){
        let realm = try! Realm()
        try! realm.write {
            realm.add(data,update: true)
        }
    }
    
    static func updateProfile(avatar:String){
        let realm = try! Realm()
        try! realm.write() {
            let data = realm.objects(User.self).first
            data?.profile = avatar
            realm.add(data!,update: true)
        }
    }
    
    
    //delete all
    static func delete(){
        let realm = try! Realm()
        let all = realm.objects(User.self)
        try! realm.write() {
            realm.delete(all)
        }
    }
    
    func print() -> String{
        return "\(self.firstName)"
    }
    
}
