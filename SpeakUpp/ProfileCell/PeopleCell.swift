//
//  PeopleCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 14/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit


class PeopleCell: BaseCell {
    
    var feed: PollAuthor? {
        didSet {
            guard let unwrapedItem = feed else {return}
            let title = unwrapedItem.isFriend ? "Following" : "Follow"
            self.followingButton.setTitle(title, for: .normal)
            self.nameLabel.text = unwrapedItem.username
            if  !(unwrapedItem.profile.isEmpty) {
                self.profileImageView.af_setImage(
                    withURL: URL(string: (unwrapedItem.profile))!,
                    placeholderImage: Mics.userPlaceHolder(),
                    imageTransition: .crossDissolve(0.2)
                )}
        }
    }
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "UserIcon")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = ""
        textView.numberOfLines = 0
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.darkText
        return textView
    }()
    
    let followingButton: UIButton = {
        let button = ViewControllerHelper.baseButton()
        let color = UIColor.white
        button.setTitle("Following", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = UIColor.hex(hex: Key.primaryHexCode)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = color.cgColor
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    
    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.white
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(followingButton)
        
        
        let margin = CGFloat(8)
        let width = frame.height - 2*margin
        self.profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        self.profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.profileImageView.layer.cornerRadius = width/2
        
        self.followingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        self.followingButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.followingButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        self.followingButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: followingButton.leadingAnchor, constant: -8).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.profileImageView.af_cancelImageRequest()
        self.profileImageView.layer.removeAllAnimations()
        self.profileImageView.image = nil
        
    }
}
