//
//  CorporateCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 04/04/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class CorporateCell: BaseCell {
    
    var homeCell: HomeCell?
    
    var feed: CorporateItem? {
        didSet {
            guard let unwrapedItem = feed else {return}
            self.nameLabel.text = unwrapedItem.name
            if  !(unwrapedItem.image.isEmpty) {
                self.profileImageView.af_setImage(
                    withURL: URL(string: (unwrapedItem.image))!,
                    placeholderImage: Mics.placeHolder(),
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
    
    let splitView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.clear
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(splitView)
        
        
        let height = frame.height - 32
        self.profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        self.profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: height).isActive = true
        self.profileImageView.layer.cornerRadius = height/2
        
        self.nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        self.splitView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        self.splitView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        self.splitView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        self.splitView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.profileImageView.af_cancelImageRequest()
        self.profileImageView.layer.removeAllAnimations()
        self.profileImageView.image = nil
        
    }
    
}
