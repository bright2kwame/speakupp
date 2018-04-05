//
//  SchoolItem.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 05/04/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import RealmSwift

class SchoolItem: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var image = ""
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func print() -> String{
        return "\(self.id)"
    }
    
}
