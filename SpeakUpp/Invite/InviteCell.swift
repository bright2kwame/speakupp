//
//  InviteCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 15/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

//
//  PeopleCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 14/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import ContactsUI


class InviteCell: BaseCell {
    
    var feed: Contact? {
        didSet {
            guard let unwrapedItem = feed else {return}
            let title = "\(unwrapedItem.contact.familyName) \(unwrapedItem.contact.givenName) \n\(unwrapedItem.contact.phoneNumbers.first?.value.stringValue ?? "0000000")"

            if unwrapedItem.isInvite {
               self.inviteButton.setTitle("Invited", for: .normal)
               self.inviteButton.backgroundColor = UIColor.white
               let color = UIColor.hex(hex: Key.primaryHexCode)
               self.inviteButton.setTitleColor(color, for: .normal)
               self.inviteButton.layer.borderColor = color.cgColor
            }  else {
               self.inviteButton.setTitle("+ invite", for: .normal)
               self.inviteButton.backgroundColor = UIColor.hex(hex: Key.primaryHexCode)
            }
            self.nameLabel.text = title
            
            if let imageDate = unwrapedItem.contact.imageData {
                self.profileImageView.image = UIImage(data: imageDate)
            }else {
               self.profileImageView.image = UIImage(named: "UserIcon")
            }
          
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
    
    let inviteButton: UIButton = {
        let button = ViewControllerHelper.baseButton()
        let color = UIColor.white
        button.setTitle("+ Invite", for: .normal)
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
        addSubview(inviteButton)
        
        let margin = CGFloat(8)
        let width = frame.height - 2*margin
        self.profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        self.profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.profileImageView.layer.cornerRadius = width/2
        
        self.inviteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        self.inviteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.inviteButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        self.inviteButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: inviteButton.leadingAnchor, constant: -8).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    
        self.profileImageView.image = nil
        
    }
}

