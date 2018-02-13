//
//  PollWithNoImageCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 06/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import AlamofireImage

class PollWithNoAudio: BaseFeedCell {
    
    override func setUpAddOnLayouts(feed: Poll) {
        
    }
    
    
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
    
    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.white
        
        self.addSubview(profileImageView)
        self.addSubview(nameLabel)
        self.addSubview(dateTimeLabel)
        self.addSubview(pollTypeLabel)
        
        
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
        
        
    }
}
