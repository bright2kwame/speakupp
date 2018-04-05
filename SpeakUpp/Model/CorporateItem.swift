//
//  CorporateItem.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 04/04/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import RealmSwift

class CorporateItem: Object {
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

