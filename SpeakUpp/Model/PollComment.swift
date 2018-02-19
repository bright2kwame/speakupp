//
//  PollComment.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 16/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import RealmSwift

class PollComment: Object {
    @objc dynamic var id = ""
    @objc dynamic var author: PollAuthor?
    @objc dynamic var elapedTime = ""
    @objc dynamic var comment = ""
 
    override class func primaryKey() -> String? {
        return "id"
    }
}
