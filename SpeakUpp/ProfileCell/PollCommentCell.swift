//
//  PollCommentCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 16/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class PollCommentCell: BaseCell {
    
    var feed: PollComment? {
        didSet {
            guard let unwrapedItem = feed else {return}
            self.timeLabel.text = unwrapedItem.elapedTime
            self.messageLabel.text = unwrapedItem.comment
            if let author = unwrapedItem.author {
                self.nameLabel.text = "@\(author.username)"
                if  !(author.profile.isEmpty) {
                    self.profileImageView.af_setImage(
                        withURL: URL(string: (author.profile))!,
                        placeholderImage: Mics.userPlaceHolder(),
                        imageTransition: .crossDissolve(0.2)
                    )}
            }
           
        }
    }
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "UserIcon")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = UIColor.hex(hex: Key.primaryHexCode)
        return textView
    }()
    
    let messageLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.darkText
        return textView
    }()
    
    
    let timeLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.font = UIFont.systemFont(ofSize: 12)
        return textView
    }()
    
    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.white
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(messageLabel)
        addSubview(timeLabel)
        
        
        let margin = CGFloat(8)
        let width = CGFloat(50)
        self.profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: width).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        self.nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        self.nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2).isActive = true
        self.messageLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        self.messageLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -2).isActive = true
        self.messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        
        self.timeLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        self.timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        self.timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        self.timeLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.profileImageView.af_cancelImageRequest()
        self.profileImageView.layer.removeAllAnimations()
        self.profileImageView.image = nil
        
    }
    
}
