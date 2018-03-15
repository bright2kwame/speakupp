//
//  Page.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 22/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import ContactsUI

struct Page {
    let imageName:String
    let title:String
    let message:String
}

struct HomeMenuLabel {
    let title:String
    let image:String
}

struct TrendingMenuLabel {
    let title:String
    let id:String
}

struct SearchMenuLabel {
    let title:String
    let type:SearchType
}


struct SettingItem {
    let title:String
    let isSelectable:Bool
    let type: SettingType
}

struct FAQItem {
    let question:String
    let answer: String
}

struct PlayerItem {
    let audioId:Int
    let audioTitle: String
    let audioUrl: String
    let audioArt: String
}

class Contact: NSObject {
    
    init(contact: CNContact,isInvite:Bool) {
        self.contact = contact
        self.isInvite = isInvite
        super.init()
    }
    var contact:CNContact
    var isInvite:Bool
    
}


