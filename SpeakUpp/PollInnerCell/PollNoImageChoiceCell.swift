//
//  PollNoImageChoice.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 09/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class PollNoImageChoiceCell: BaseCell {
    
    
    var feed: PollChoice? {
        didSet {
            guard let unwrapedItem = feed else {return}
            self.optionTextLabel.text = unwrapedItem.choiceText
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.optionImageView.image = isSelected ? UIImage(named:"CheckBoxSelect"): UIImage(named: "CheckBox")
        }
    }
    
    let optionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderWidth = 0
        imageView.image = UIImage(named: "CheckBox")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let optionTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = ""
        textView.numberOfLines = 0
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.darkGray
        return textView
    }()
    
    override func setUpView() {
        super.setUpView()
        self.backgroundColor = UIColor.white
        
        self.addSubview(optionImageView)
        self.addSubview(optionTextLabel)
       
        self.optionImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        self.optionImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        self.optionImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.optionImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        
        self.optionTextLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        self.optionTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        self.optionTextLabel.leadingAnchor.constraint(equalTo: optionImageView.trailingAnchor, constant: 5).isActive = true
        self.optionTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
    }
    
}
