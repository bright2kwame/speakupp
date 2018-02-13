//
//  WordCloudCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 12/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class  WordCloudCell: BaseCell {
    
    var feed: UserWorkCloud? {
        didSet {
            guard let unwrapedItem = feed else {return}
            self.nameLabel.text = unwrapedItem.name
            let fontSize = CGFloat(unwrapedItem.cloudValue + 8.0)
            self.nameLabel.font =  UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    let nameLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.text = ""
        textView.numberOfLines = 0
        textView.font = UIFont.systemFont(ofSize: 8)
        textView.textColor = UIColor.white
        return textView
    }()
    

    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.clear
        addSubview(nameLabel)
        
        self.nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        
    }
}
