//
//  AWSCredentials.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 13/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import RealmSwift

class AWSCredentails: Object {
    @objc dynamic var secretKey = ""
    @objc dynamic var accessKey = ""
    @objc dynamic var region = ""
    @objc dynamic var bucketName = ""
    
    override class func primaryKey() -> String? {
        return "secretKey"
    }
    
    
    
    //delete all
    static func delete(){
        let realm = try! Realm()
        let all = realm.objects(AWSCredentails.self)
        try! realm.write() {
            realm.delete(all)
        }
    }
    
    //get data
    static func getUser() -> AWSCredentails?{
        let realm = try! Realm()
        return realm.objects(AWSCredentails.self).first
    }
    
    //save
    static func save(data: AWSCredentails) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(data,update: true)
        }
    }
    
}

