//
//  PollImageChoiceCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 09/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import AlamofireImage
import EFAutoScrollLabel


class PollImageChoiceCell: BaseCell {
    
    
    var feed: PollChoice? {
        didSet {
            guard let unwrapedItem = feed else {return}
            self.optionTextLabel.text = unwrapedItem.choiceText
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let nsNumber = NSNumber(value: unwrapedItem.numOfVotes)
            self.voteCountTextLabel.attributedText = "\(numberFormatter.string(from: nsNumber)!)".formatAttributedWithImage(image: "VoteNumber")
            
            self.voteCountTextLabel.minimumScaleFactor = 0.2
            self.voteCountTextLabel.lineBreakMode = .byCharWrapping
            self.voteCountTextLabel.adjustsFontSizeToFitWidth = true
            self.voteCountTextLabel.textAlignment = .left
            
            if  !(unwrapedItem.image.isEmpty) {
                self.optionImageView.af_setImage(
                    withURL: URL(string: (unwrapedItem.image))!,
                    placeholderImage: Mics.placeHolder(),
                    imageTransition: .crossDissolve(0.2)
            )}
            
        }
    }
    
    override var isSelected: Bool {
        didSet {
           self.voteCoverView.isHidden = isSelected ? false: true
           self.voteStackView.isHidden = isSelected ? false: true
        }
    }
    
    lazy var voteCoverView:  UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.8
        blurEffectView.isHidden = true
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    let optionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderWidth = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let optionTextLabel: EFAutoScrollLabel = {
        let label = ViewControllerHelper.baseScrollingLabel()
        return label
    }()
    
    let voteCountTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = ""
        textView.numberOfLines = 1
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textColor = UIColor.white
        return textView
    }()
    
    lazy var coverView:  UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    lazy var voteStackView:  UIStackView = {
        let stackView =  UIStackView(arrangedSubviews: [acceptImageView,rejectImageView])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.isHidden = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let acceptImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = UIImage(named: "VoteThumbsUp")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.backgroundColor = UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.0)
        imageView.layer.borderWidth = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let rejectImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = UIImage(named: "VoteThumbsDown")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.backgroundColor = UIColor.white
        imageView.layer.borderWidth = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func setUpView() {
        super.setUpView()
        self.backgroundColor = UIColor.white
        
        
        self.addSubview(optionImageView)
        self.addSubview(coverView)
        self.addSubview(optionTextLabel)
        self.addSubview(voteCountTextLabel)
        self.addSubview(voteCoverView)
        self.addSubview(voteStackView)
        
        self.voteCoverView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        self.voteCoverView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        self.voteCoverView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        self.voteCoverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        
        self.optionImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        self.optionImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        self.optionImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        self.optionImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        
        self.coverView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.coverView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        self.coverView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        self.coverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        
        let width = frame.width - 80
        self.voteCountTextLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.voteCountTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        self.voteCountTextLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.voteCountTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
       
        self.optionTextLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.optionTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        self.optionTextLabel.leadingAnchor.constraint(equalTo: voteCountTextLabel.trailingAnchor, constant: 2).isActive = true
        self.optionTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2).isActive = true
        
        let margin = frame.width/4
        self.voteStackView.topAnchor.constraint(equalTo: topAnchor,constant: margin).isActive = true
        self.voteStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
        self.voteStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        self.voteStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin).isActive = true
        
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            self.optionImageView.af_cancelImageRequest()
            self.optionImageView.layer.removeAllAnimations()
            self.optionImageView.image = nil
            
            self.optionTextLabel.text = ""
            self.voteCountTextLabel.text = ""
    }
}
