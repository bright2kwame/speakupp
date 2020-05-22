//
//  QuizItem.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 02/01/2020.
//  Copyright © 2020 Bright Limited. All rights reserved.
//

import RealmSwift

class QuizItem: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var prize = ""
    @objc dynamic var entryFee = 0.0
    @objc dynamic var hasPaid = false
 
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func print() -> String{
        return "\(self.id)"
    }
}

