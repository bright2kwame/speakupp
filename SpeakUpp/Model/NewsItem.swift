//
//  NewsItem.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 30/05/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import RealmSwift

class NewsItem: Object {
    @objc dynamic var id = ""
    @objc dynamic var title = ""
    @objc dynamic var content = ""
    @objc dynamic var image = ""
    @objc dynamic var hasLiked = false
    @objc dynamic var numOfComments = 0
    @objc dynamic var numOfLikes = 0
 
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func print() -> String{
        return "\(self.id)"
    }
    
}
