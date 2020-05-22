//
//  QuestionItem.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 02/01/2020.
//  Copyright © 2020 Bright Limited. All rights reserved.
//

import RealmSwift

class QuestionItem: Object {
    @objc dynamic var id = ""
    @objc dynamic var hasImage = false
    @objc dynamic var question = ""
    @objc dynamic var questionImage = ""
    @objc dynamic var hasImageAnswers = false
    @objc dynamic var isBonus = false
    var answers = List<AnswerItem>()
 
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func print() -> String{
        return "\(self.id)"
    }
    
}

