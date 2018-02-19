//
//  BaseRatingCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 08/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

//
//  BaseFeedCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 29/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import AlamofireImage
import Cosmos

class BaseRatingCell: BaseCell {
   
    var feed: Poll? {
        didSet {
            guard let unwrapedItem = feed else {return}
            self.pollTypeLabel.text = unwrapedItem.pollType.formatPollType().uppercased()
            self.likeButton.setTitle("\(unwrapedItem.numOfLikes)", for: .normal)
            self.commentButton.setTitle("\(unwrapedItem.numOfComments)", for: .normal)
            self.nameLabel.text = unwrapedItem.author?.username
            self.dateTimeLabel.text = "\(unwrapedItem.elapsedTime)\n\(unwrapedItem.expiryDate)"
            if let author = unwrapedItem.author {
                if  !(author.profile.isEmpty) {
                    self.profileImageView.af_setImage(
                        withURL: URL(string: (author.profile))!,
                        placeholderImage: Mics.placeHolder(),
                        imageTransition: .crossDissolve(0.2)
                    )}
            }
            
            //question image
            self.questionLabel.text = unwrapedItem.question

            if  !(unwrapedItem.image.isEmpty) {
                self.questionImageView.isHidden = false
                self.questionImageView.af_setImage(
                    withURL: URL(string: (unwrapedItem.image))!,
                    placeholderImage: Mics.placeHolder(),
                    imageTransition: .crossDissolve(0.2)
                )}else {
                self.questionImageView.isHidden = true
                self.questionLabel.isHidden = false
            }
            
            
            if unwrapedItem.hasVoted {
                self.ratingView.rating = Double(unwrapedItem.totalAverageRating)
                self.ratesLabel.text = "\(Mics.formatNumber(number: unwrapedItem.totalRatingVotes,text: "Rating"))\n\(unwrapedItem.totalAverageRating)"
                self.ratingView.settings.updateOnTouch = false
            } else {
                self.ratingView.settings.updateOnTouch = true
                self.ratingView.rating = Double(5.0)
                self.ratesLabel.text = ""
               
            }
        }
    }
    
    let ratingView: CosmosView = {
        let cosmosView = CosmosView()
        cosmosView.rating = 5
        cosmosView.settings.updateOnTouch = true
        cosmosView.settings.fillMode = .full
        cosmosView.settings.starSize = 30
        cosmosView.settings.starMargin = 5
        cosmosView.settings.filledColor = UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.0)
        cosmosView.settings.emptyBorderColor = UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.0)
        cosmosView.settings.filledBorderColor = UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.0)
        cosmosView.translatesAutoresizingMaskIntoConstraints = false
        return cosmosView
    }()
    

    let shareButton: UIButton = {
        let button = ViewControllerHelper.plainImageButton()
        button.tintColor = UIColor.darkGray
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setImage(UIImage(named: "Share"), for: .normal)
        button.setTitle("", for: .normal)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = ViewControllerHelper.plainImageButton()
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.tintColor = UIColor.darkGray
        button.setImage(UIImage(named:"Comment"), for: .normal)
        button.setTitle("10", for: .normal)
        return button
    }()
    
    let likeButton: UIButton = {
        let button = ViewControllerHelper.plainImageButton()
        button.tintColor = UIColor.darkGray
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setImage(UIImage(named: "Like"), for: .normal)
        button.setTitle("20", for: .normal)
        return button
    }()
    
    let dividerView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.groupTableViewBackground
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    let questionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderWidth = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    let questionLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 24)
        textView.textColor = UIColor.darkGray
        return textView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "UserIcon")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = "*******"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.darkGray
        return textView
    }()
    
    let dateTimeLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = "*******"
        textView.font = UIFont.systemFont(ofSize: 10)
        textView.textColor = UIColor.darkGray
        return textView
    }()
    
    let pollTypeLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.text = "*******"
        textView.font = UIFont.systemFont(ofSize: 10)
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor.red
        return textView
    }()
    
    let ratesLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.text = "0 rating\n5.0"
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = UIColor.darkGray
        return textView
    }()
    
    
    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.white
        
        self.addSubview(profileImageView)
        self.addSubview(nameLabel)
        self.addSubview(dateTimeLabel)
        self.addSubview(pollTypeLabel)
        self.addSubview(questionLabel)
        self.addSubview(questionImageView)
        self.addSubview(dividerView)
        self.addSubview(ratesLabel)
        self.addSubview(ratingView)
        
        self.profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.pollTypeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        self.pollTypeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        self.pollTypeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.pollTypeLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: pollTypeLabel.leadingAnchor, constant: -8).isActive = true
        self.nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.dateTimeLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        self.dateTimeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        self.dateTimeLabel.trailingAnchor.constraint(equalTo: pollTypeLabel.leadingAnchor, constant: -8).isActive = true
        self.dateTimeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        self.questionLabel.topAnchor.constraint(equalTo: dateTimeLabel.bottomAnchor, constant: 16).isActive = true
        self.questionLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        self.questionImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        self.questionImageView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 16).isActive = true
        self.questionImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.questionImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        self.ratingView.topAnchor.constraint(equalTo: questionImageView.bottomAnchor, constant: 8).isActive = true
        self.ratingView.bottomAnchor.constraint(equalTo: ratesLabel.topAnchor, constant: -8).isActive = true
        self.ratingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
       
        self.ratesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        self.ratesLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.ratesLabel.bottomAnchor.constraint(equalTo: dividerView.topAnchor, constant: -8).isActive = true
        self.ratesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
       
       
        let container = UIStackView(arrangedSubviews: [likeButton,commentButton,shareButton])
        container.distribution = .fillEqually
        container.axis = .horizontal
        container.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(container)
        
        container.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8).isActive = true
        container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        container.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.dividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.dividerView.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -8).isActive = true
        self.dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.dividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        
       
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profileImageView.af_cancelImageRequest()
        self.profileImageView.layer.removeAllAnimations()
        self.profileImageView.image = nil
        
        self.questionImageView.af_cancelImageRequest()
        self.questionImageView.layer.removeAllAnimations()
        self.questionImageView.image = nil
        
        self.questionLabel.text = ""

    }
}



