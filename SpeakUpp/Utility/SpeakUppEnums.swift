//
//  SpeakUppEnums.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 24/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//


enum MessageType {
    case failed
    case success
    case warning
    case info
}

enum SearchType {
    case poll
    case people
    case brands
    case events
}

enum SettingType {
    case sound
    case notification
    case log
    case profile
    case faq
    case privacy
    case contact
    case friend
    case about
}

enum TrackType {
    case video
    case audio
    case text
}

enum HomeTabsType: String {
    case CORPORATE = "CORPORATE"
    case SCHOOLS = "NOT FOR PROFIT"
    case TIMELINE = "TIMELINE"
}


