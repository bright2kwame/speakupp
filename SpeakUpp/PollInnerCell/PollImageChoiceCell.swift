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
    
    let voteCoverView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
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
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Accept")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderWidth = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let rejectImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Deny")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderWidth = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let maximizeButton: UIButton = {
        let button = ViewControllerHelper.baseButton()
        button.layer.borderWidth = 0
        button.backgroundColor = UIColor(white: 0, alpha: 0.5)
        button.imageEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        button.setImage(UIImage(named: "Maximize"), for: .normal)
        return button
    }()
    
    override func setUpView() {
        super.setUpView()
        self.backgroundColor = UIColor.white
        
        
        self.addSubview(optionImageView)
        self.addSubview(coverView)
        self.addSubview(optionTextLabel)
        self.addSubview(voteCountTextLabel)
        self.addSubview(maximizeButton)
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
        
        
        self.maximizeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.maximizeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        self.maximizeButton.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        self.maximizeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
        
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
