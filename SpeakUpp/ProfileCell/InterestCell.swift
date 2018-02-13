//
//  InterestCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 12/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class InterestCell: BaseCell {
    var feed: PollCategory? {
        didSet {
            guard let unwrapedItem = feed else {return}
            let title = unwrapedItem.isInterested ? "-" : "+"
            self.actionButton.setTitle(title, for: .normal)
            self.nameLabel.text = unwrapedItem.name
            if  !(unwrapedItem.imageUrl.isEmpty) {
                self.profileImageView.af_setImage(
                    withURL: URL(string: (unwrapedItem.imageUrl))!,
                    placeholderImage: Mics.userPlaceHolder(),
                    imageTransition: .crossDissolve(0.2)
                )}
        }
    }
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = nil
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = ""
        textView.numberOfLines = 0
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.white
        return textView
    }()
    
    let actionButton: UIButton = {
        let button = ViewControllerHelper.baseButton()
        let color = UIColor.white
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.backgroundColor = UIColor.hex(hex: Key.primaryHexCode)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = color.cgColor
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    lazy var coverView:  UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.5
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    
    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.white
        
        addSubview(profileImageView)
        addSubview(coverView)
        addSubview(nameLabel)
        addSubview(actionButton)
        
        
        self.profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        self.profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        self.profileImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        
        self.coverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.coverView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        self.coverView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        self.coverView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
       
        self.actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        self.actionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.actionButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        self.actionButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: 8).isActive = true
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
