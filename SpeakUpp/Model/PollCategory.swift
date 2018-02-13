//
//  PollCategory.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 06/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import RealmSwift

class PollCategory: Object {
    @objc dynamic var id = ""
    @objc dynamic var totalPolls = 0
    @objc dynamic var name = ""
    @objc dynamic var imageUrl = ""
    @objc dynamic var hexValue = ""
    @objc dynamic var isInterested = false
    

    override class func primaryKey() -> String? {
        return "id"
    }
}
