//
//  Feed.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 29/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import RealmSwift

class Feed: Object {
    @objc dynamic var id = ""
   
    
    override class func primaryKey() -> String? {
        return "id"
    }
    

}
