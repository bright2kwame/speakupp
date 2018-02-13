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
            
            if  !(unwrapedItem.image.isEmpty) {
                self.imageView.af_setImage(
                    withURL: URL(string: (unwrapedItem.image))!,
                    placeholderImage: Mics.placeHolder(),
                    imageTransition: .crossDissolve(0.2)
                )}

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
        
        self.addSubview(imageView)
        self.addSubview(coverView)
        self.addSubview(titleTextLabel)
        self.addSubview(dateTextLabel)
        
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
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.af_cancelImageRequest()
        self.imageView.layer.removeAllAnimations()
        self.imageView.image = nil
        
    }
}
