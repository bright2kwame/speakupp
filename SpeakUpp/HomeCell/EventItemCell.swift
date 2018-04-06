//
//  EventItemCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 30/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import AlamofireImage


class EventItemCell: BaseCell {
    
    var feed: Poll? {
        didSet {
            guard let unwrapedItem = feed else {return}
            //question image
            let shadow = NSShadow()
            shadow.shadowBlurRadius = 0.5
            shadow.shadowOffset = CGSize(width: 0.2, height: 0.2)
            shadow.shadowColor = UIColor.black
            let myAttribute = [ NSAttributedStringKey.shadow: shadow ]
            let myAttrString = NSAttributedString(string: unwrapedItem.eventTitle, attributes: myAttribute)
            self.titleTextLabel.attributedText = myAttrString
            
            self.dateTextLabel.text = unwrapedItem.eventStartDate.formateAsShortDate()
            self.priceTextLabel.text = unwrapedItem.price
            
            if  !(unwrapedItem.image.isEmpty) {
                self.imageView.af_setImage(
                    withURL: URL(string: (unwrapedItem.image))!,
                    placeholderImage: Mics.placeHolder(),
                    imageTransition: .crossDissolve(0.2)
                )}

            if unwrapedItem.hasTicket {
                self.actionButton.isHidden = false
                self.priceTextLabel.isHidden = false
                self.uiView.isHidden = false
                let color = UIColor.hex(hex: Key.primaryHexCode)
                if unwrapedItem.hasPurchased {
                    self.actionButton.setTitle("View Ticket", for: .normal)
                    self.actionButton.backgroundColor = UIColor.white
                    self.actionButton.setTitleColor(color, for: .normal)
                } else {
                   self.actionButton.setTitle("Buy Ticket", for: .normal)
                   self.actionButton.backgroundColor = color
                   self.actionButton.setTitleColor(UIColor.white, for: .normal)
                }
            }else {
                self.actionButton.isHidden = true
                self.priceTextLabel.isHidden = true
                self.uiView.isHidden = true
            }
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderWidth = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 24)
        textView.textColor = UIColor.white
        return textView
    }()
    
    let dateTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.white
        return textView
    }()
    
    
    let coverView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    let actionButton: UIButton = {
        let button = ViewControllerHelper.baseButton()
        let color = UIColor.white
        button.setTitle("Buy Ticket", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = UIColor.hex(hex: Key.primaryHexCode)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 0
        button.layer.borderColor = color.cgColor
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    let priceTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 24)
        textView.textColor = UIColor.white
        return textView
    }()
    
    let uiView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.2)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.white
        
        self.addSubview(imageView)
        self.addSubview(coverView)
        self.addSubview(titleTextLabel)
        self.addSubview(dateTextLabel)
        self.addSubview(actionButton)
        self.addSubview(uiView)
        self.addSubview(priceTextLabel)
        
        self.imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        self.imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        self.coverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.coverView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        self.coverView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        self.coverView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        self.titleTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        self.titleTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        self.titleTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
        self.titleTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
        
        self.dateTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        self.dateTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
        self.dateTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
        self.dateTextLabel.topAnchor.constraint(equalTo: titleTextLabel.bottomAnchor, constant: 8).isActive = true
        
        
        self.priceTextLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.priceTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
        self.priceTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
        self.priceTextLabel.bottomAnchor.constraint(equalTo: uiView.topAnchor, constant: -5).isActive = true
        
        let width = frame.width/3
        self.uiView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        self.uiView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        self.uiView.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.uiView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -8).isActive = true
    
        self.actionButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        self.actionButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.actionButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.actionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.af_cancelImageRequest()
        self.imageView.layer.removeAllAnimations()
        self.imageView.image = nil
        
    }
}
