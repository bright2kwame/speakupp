//
//  PollOption.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 25/06/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//


import RealmSwift

class PollOption: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var imageUrl = ""
    @objc dynamic var poll: Poll?
    @objc dynamic var selectedState = 0

    override class func primaryKey() -> String? {
        return "id"
    }
    
    func formatVote() -> String {
        return "\(id):\(selectedState)"
    }
}
