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
    case POLLS = "POLLS"
    case NEWS = "FINDINGS"
    case TIMELINE = "TIMELINE"
}

enum PollType: String {
    case PAID_POLL = "paid_poll"
    case MULTIPLE = "choices_multiple_rating"
}



