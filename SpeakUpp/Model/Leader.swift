//
//  Leader.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 14/12/2019.
//  Copyright © 2019 Bright Limited. All rights reserved.
//

import RealmSwift

class Leader: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var avatar = ""
    @objc dynamic var position = ""
    @objc dynamic var point = ""
 
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func print() -> String{
        return "\(self.id)"
    }
    
}

