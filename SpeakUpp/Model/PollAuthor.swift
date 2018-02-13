//
//  Feed.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 29/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import RealmSwift

class PollAuthor: Object {
    @objc dynamic var id = ""
    @objc dynamic var avatar = ""
    @objc dynamic var profile = ""
    @objc dynamic var brandName = ""
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var username = ""
    @objc dynamic var birthday = ""
    @objc dynamic var country = ""
   
    override class func primaryKey() -> String? {
        return "id"
    }
}
