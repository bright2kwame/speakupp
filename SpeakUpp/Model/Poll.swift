//
//  Polls.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 06/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import RealmSwift

class Poll: Object {
    @objc dynamic var id = ""
    @objc dynamic var eventDescription = ""
    @objc dynamic var eventLocation = ""
    @objc dynamic var eventTitle = ""
    @objc dynamic var eventTime = ""
    @objc dynamic var eventStartDate = ""
    @objc dynamic var eventEndDate = ""
    @objc dynamic var author: PollAuthor?
    @objc dynamic var category: PollCategory?
    var pollChoice = List<PollChoice>()
    @objc dynamic var ratingOptions = ""
    @objc dynamic var pricePerSMS = ""
    @objc dynamic var isAudio = false
    @objc dynamic var hasExpired = false
    @objc dynamic var hasImages = false
    @objc dynamic var hasLiked = false
    @objc dynamic var isShared = false
    @objc dynamic var isBinary = false
    @objc dynamic var hasVoted = false
    @objc dynamic var hasTicket = false
    @objc dynamic var hasPurchased = false
    @objc dynamic var totalVotes = 0
    @objc dynamic var totalRatingVotes = 0
    @objc dynamic var numOfComments = 0
    @objc dynamic var numOfShares = 0
    @objc dynamic var numOfLikes = 0
    @objc dynamic var totalAverageRating = 0
    @objc dynamic var expiryDate = ""
    @objc dynamic var pollType = ""
    @objc dynamic var image = ""
    @objc dynamic var longitude = ""
    @objc dynamic var latitude = ""
    @objc dynamic var audio = ""
    @objc dynamic var resultVisibity = ""
    @objc dynamic var shortCode = ""
    @objc dynamic var elapsedTime = ""
    @objc dynamic var question = ""
    @objc dynamic var price = ""
    @objc dynamic var votedOption = ""
    var vottingOptions = List<PollOption>()
    
    

    override class func primaryKey() -> String? {
        return "id"
    }
    
    func print() -> String{
        return "\(self.id)"
    }
    
}
