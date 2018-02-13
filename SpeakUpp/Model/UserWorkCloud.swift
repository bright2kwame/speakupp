//
//  UserWorkCloud.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 12/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import RealmSwift

class UserWorkCloud: Object {
    @objc dynamic var id = ""
    @objc dynamic var cloudValue = 0.0
    @objc dynamic var name = ""

    override class func primaryKey() -> String? {
        return "id"
    }
    
    //save user
    static func save(data: UserWorkCloud) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(data,update: true)
        }
    }
    
    //get all
    static func getAll() -> [UserWorkCloud]{
        let realm = try! Realm()
        return Array(realm.objects(UserWorkCloud.self))
    }
    
    //delete all
    static func delete(){
        let realm = try! Realm()
        let all = realm.objects(UserWorkCloud.self)
        try! realm.write() {
            realm.delete(all)
        }
    }
}
