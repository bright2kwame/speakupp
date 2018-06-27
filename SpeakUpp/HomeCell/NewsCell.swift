//
//  NewsCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 30/05/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit



import UIKit

class NewsCell: BaseCell {
    
    var homeCell: HomeCell?
    
    
    var item: NewsItem? {
        didSet {
            guard let unwrapedItem = item else {return}
            self.likeButton.setTitle("\(Mics.suffixNumber(numberInt: unwrapedItem.numOfLikes))", for: .normal)
            self.commentButton.setTitle("\(Mics.suffixNumber(numberInt: unwrapedItem.numOfComments))", for: .normal)
            if unwrapedItem.hasLiked {
                self.likeButton.setImage(UIImage(named: "LikeActive"), for: .normal)
                self.likeButton.setTitleColor(UIColor.hex(hex: Key.primaryHexCode), for: .normal)
            }   else {
                self.likeButton.setImage(UIImage(named: "Like"), for: .normal)
                self.likeButton.setTitleColor(UIColor.darkGray, for: .normal)
            }
            if  !(unwrapedItem.image.isEmpty) {
                self.imageView.af_setImage(
                    withURL: URL(string: (unwrapedItem.image))!,
                    placeholderImage: Mics.placeHolder(),
                    imageTransition: .crossDissolve(0.2)
                )}
            
            
            let header = "\(unwrapedItem.title)\n\n".attributeText(fontSize: 16)
            let content = "\(unwrapedItem.content)".attributeText(fontSize: 14)
            let resultingAmount = NSMutableAttributedString()
            resultingAmount.append(header)
            resultingAmount.append(content)
            
            self.contentLabel.attributedText = resultingAmount
            
        }
    }

    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let contentLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.numberOfLines = 8
        return textView
    }()
    
    let commentButton: UIButton = {
        let button = ViewControllerHelper.plainImageButton()
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.tintColor = UIColor.hex(hex: Key.primaryHexCode)
        button.setImage(UIImage(named:"Comment"), for: .normal)
        button.setTitle("**", for: .normal)
        return button
    }()
    
    let likeButton: UIButton = {
        let button = ViewControllerHelper.plainImageButton()
        button.tintColor = UIColor.hex(hex: Key.primaryHexCode)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setImage(UIImage(named: "Like"), for: .normal)
        button.setTitle("**", for: .normal)
        return button
    }()
    
    let dividerView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.groupTableViewBackground
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.white
        
        addSubview(imageView)
        addSubview(contentLabel)
        addSubview(dividerView)
        addSubview(likeButton)
        addSubview(commentButton)
       
        self.imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        self.imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        self.contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        self.contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        self.contentLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        self.contentLabel.bottomAnchor.constraint(equalTo: dividerView.topAnchor, constant: -16).isActive = true
        
        
        let container = UIStackView(arrangedSubviews: [likeButton,commentButton])
        container.distribution = .fillEqually
        container.axis = .horizontal
        container.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(container)
        
        container.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8).isActive = true
        container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        container.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.dividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        self.dividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        self.dividerView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        self.dividerView.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -8).isActive = true
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.af_cancelImageRequest()
        self.imageView.layer.removeAllAnimations()
        self.imageView.image = nil
        
    }
    
}
