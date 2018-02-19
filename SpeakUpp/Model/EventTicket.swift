//
//  EventTicket.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 17/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import RealmSwift

class EventTicket: Object {
    @objc dynamic var id = ""
    @objc dynamic var author: PollAuthor?
    @objc dynamic var poll: Poll?
    @objc dynamic var totalAmount = ""
    @objc dynamic var isUsed = false
    @objc dynamic var quantity = 1
    @objc dynamic var orderNumber = ""
    @objc dynamic var dateRedeemed = ""
    

    override class func primaryKey() -> String? {
        return "id"
    }
    
    func print() -> String{
        return "\(self.id)"
    }
    
}

