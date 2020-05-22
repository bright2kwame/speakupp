//
//  AnswerItem.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 02/01/2020.
//  Copyright © 2020 Bright Limited. All rights reserved.
//

import RealmSwift

class AnswerItem: Object {
    @objc dynamic var id = ""
    @objc dynamic var answer = ""
    @objc dynamic var image = ""
 
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func print() -> String{
        return "\(self.id)"
    }
}
