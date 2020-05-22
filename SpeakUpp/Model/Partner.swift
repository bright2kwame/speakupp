//
//  Partner.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 14/12/2019.
//  Copyright © 2019 Bright Limited. All rights reserved.
//

import RealmSwift

class Partner: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var contact = ""
    @objc dynamic var image = ""
    @objc dynamic var offer = ""
    @objc dynamic var categoryName = ""
    @objc dynamic var latitude = ""
    @objc dynamic var longitude = ""
  

    override class func primaryKey() -> String? {
        return "id"
    }
    
    func print() -> String{
        return "\(self.id)"
    }
    
}
