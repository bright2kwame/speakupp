//
//  PollChoice.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 06/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import RealmSwift

class PollChoice: Object {
    @objc dynamic var poll: Poll?
    @objc dynamic var id = ""
    @objc dynamic var shortCodeText = ""
    @objc dynamic var resultPercent = ""
    @objc dynamic var choiceText = ""
    @objc dynamic var numOfVotes = 0
    @objc dynamic var image = ""
    @objc dynamic var choiceDescription = ""
    @objc dynamic var audio = ""
   
    override class func primaryKey() -> String? {
        return "id"
    }
}
