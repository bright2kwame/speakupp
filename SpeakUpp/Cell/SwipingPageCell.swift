//
//  SwipingPageCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 22/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class SwipingPageCell: BaseCell {
    
    var page: Page? {
        didSet {
            guard let unwrapedPage = page else {return}
            mainImageView.image = UIImage(named: unwrapedPage.imageName)
            
            let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 30)]
            let andAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
            
            let header = NSMutableAttributedString(string: "\(unwrapedPage.title)", attributes: attributes)
            let and = NSMutableAttributedString(string: "\n\n\(unwrapedPage.message)", attributes: andAttributes)
            
            let combinedText = NSMutableAttributedString()
            combinedText.append(header)
            combinedText.append(and)
            
            detailTextView.attributedText = combinedText
            detailTextView.textAlignment = .center
        }
    }
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    let detailTextView: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.textColor = UIColor.white
        return textView
    }()
    
    
    override func setUpView(){
        backgroundColor = UIColor.clear
        addSubview(mainImageView)
        addSubview(detailTextView)
        
        mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        mainImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: detailTextView.topAnchor, constant: -16).isActive = true
        
        detailTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        detailTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        detailTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        detailTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24).isActive = true
        detailTextView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
    }
}

