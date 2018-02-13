//
//  Brand.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 12/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import RealmSwift

class Brand: Object {
    @objc dynamic var id = ""
    @objc dynamic var author: PollAuthor?
    @objc dynamic var isFriend = false

    override class func primaryKey() -> String? {
        return "id"
    }
    
    func print() -> String{
        return "\(self.id)"
    }
    
}
