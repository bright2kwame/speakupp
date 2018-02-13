//
//  BaseFeedCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 29/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import AlamofireImage

class TrendingItemCell: BaseCell {

    var feed: Poll? {
        didSet {
            guard let unwrapedItem = feed else {return}
            self.questionLabel.text = unwrapedItem.question
            self.iconImageView.image = UIImage(named: "Graph")
        }
    }
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Graph")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let questionLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = ""
        textView.numberOfLines = 0
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.darkGray
        return textView
    }()

    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.white
        
        self.addSubview(iconImageView)
        self.addSubview(questionLabel)
       
        self.iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        self.iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        self.iconImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        
        self.questionLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16).isActive = true
        self.questionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        self.questionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        self.questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
    
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.iconImageView.af_cancelImageRequest()
        self.iconImageView.layer.removeAllAnimations()
        self.iconImageView.image = nil
        
    }
}

