//
//  PollOptionCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 25/06/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import AlamofireImage



class PollOptionCell: BaseCell {
    
    var feed: PollOption? {
        didSet {
            guard let unwrapedItem = feed else {return}
            //question image
            self.noImageQuestionLabel.text = unwrapedItem.name
            if  !(unwrapedItem.imageUrl.isEmpty) {
                self.questionImageView.af_setImage(
                    withURL: URL(string: (unwrapedItem.imageUrl))!,
                    placeholderImage: Mics.placeHolder(),
                    imageTransition: .crossDissolve(0.2)
                )}
            
            guard let _ = unwrapedItem.poll else {return}
            self.pollTypeLabel.text = unwrapedItem.poll?.pollType.formatPollType().uppercased()
            self.nameLabel.text = unwrapedItem.poll?.author?.username
            self.dateTimeLabel.text = "\(unwrapedItem.poll?.elapsedTime ?? "Now" )\n\(unwrapedItem.poll?.expiryDate ?? "Now" )"
            
            //MARK- like configuration
            if let author = unwrapedItem.poll?.author {
                if  !(author.profile.isEmpty) {
                    self.profileImageView.af_setImage(
                        withURL: URL(string: (author.profile))!,
                        placeholderImage: Mics.placeHolder(),
                        imageTransition: .crossDissolve(0.2)
                    )}
            }
        
        }
    }
    
    
    let shareButton: UIButton = {
        let button = ViewControllerHelper.plainImageButton()
        button.tintColor = UIColor.hex(hex: Key.primaryHexCode)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setImage(UIImage(named: "voteThumbsDown"), for: .normal)
        button.setTitle("No", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()

    let likeButton: UIButton = {
        let button = ViewControllerHelper.plainImageButton()
        button.tintColor = UIColor.hex(hex: Key.primaryHexCode)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setImage(UIImage(named: "voteThumbsUp"), for: .normal)
        button.setTitle("Yes", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
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
  
    let noImageQuestionLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 20)
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
    
    let actionView: UIView = {
        let uiView = UIView()
        uiView.layer.cornerRadius = 25
        uiView.backgroundColor = UIColor.groupTableViewBackground
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()

    
    
    
    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.white
        
        self.addSubview(profileImageView)
        self.addSubview(nameLabel)
        self.addSubview(dateTimeLabel)
        self.addSubview(pollTypeLabel)
        self.addSubview(noImageQuestionLabel)
        self.addSubview(questionImageView)
        self.addSubview(dividerView)
        self.addSubview(actionView)
        
        
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
        self.dateTimeLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.noImageQuestionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        self.noImageQuestionLabel.topAnchor.constraint(equalTo: dateTimeLabel.bottomAnchor, constant: 16).isActive = true
        self.noImageQuestionLabel.heightAnchor.constraint(equalToConstant: 120).isActive = true
        self.noImageQuestionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        
        let container = UIStackView(arrangedSubviews: [likeButton,shareButton])
        container.distribution = .fillEqually
        container.axis = .horizontal
        container.translatesAutoresizingMaskIntoConstraints = false
        actionView.addSubview(container)
        
        actionView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8).isActive = true
        actionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        actionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        actionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.bottomAnchor.constraint(equalTo: actionView.bottomAnchor,constant: 0).isActive = true
        container.trailingAnchor.constraint(equalTo: actionView.trailingAnchor, constant: 0).isActive = true
        container.leadingAnchor.constraint(equalTo: actionView.leadingAnchor, constant: 0).isActive = true
        container.topAnchor.constraint(equalTo: actionView.topAnchor, constant: 0).isActive = true
       
        
        self.likeButton.backgroundColor = UIColor.hex(hex: "4A90E2")
        self.likeButton.layer.cornerRadius = 25
        self.shareButton.layer.cornerRadius = 25
        
        self.dividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.dividerView.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -8).isActive = true
        self.dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.dividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        
        self.questionImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        self.questionImageView.topAnchor.constraint(equalTo: noImageQuestionLabel.bottomAnchor, constant: 16).isActive = true
        self.questionImageView.bottomAnchor.constraint(equalTo: dividerView.topAnchor, constant: -16).isActive = true
        self.questionImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profileImageView.af_cancelImageRequest()
        self.profileImageView.layer.removeAllAnimations()
        self.profileImageView.image = nil
        
        self.questionImageView.af_cancelImageRequest()
        self.questionImageView.layer.removeAllAnimations()
        self.questionImageView.image = nil
        
    }
}

