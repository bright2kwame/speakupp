//
//  PollAudioCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 14/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import EFAutoScrollLabel

class PollAudioChoiceCell: BaseCell {
    
    var feed: PollChoice? {
        didSet {
            guard let unwrapedItem = feed else {return}
            self.optionTextLabel.text = unwrapedItem.choiceText
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.playImageView.image = isSelected ? UIImage(named:"Pause"): UIImage(named: "Play")
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
    
    
    let optionTextLabel: EFAutoScrollLabel = {
        let label = ViewControllerHelper.baseScrollingLabel()
        return label
    }()

    let playImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderWidth = 0
        imageView.image = UIImage(named: "Play")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var bgCoverView:  UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderWidth = 0
        imageView.image = UIImage(named: "AudioWave")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func setUpView() {
        super.setUpView()
        self.backgroundColor = UIColor.white
        
        self.addSubview(bgImageView)
        self.addSubview(bgCoverView)
        self.addSubview(optionImageView)
        self.addSubview(optionTextLabel)
        self.addSubview(playImageView)
        
        self.bgImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.bgImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        self.bgImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        self.bgImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        
        self.bgCoverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.bgCoverView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        self.bgCoverView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        self.bgCoverView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        
        self.optionImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        self.optionImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        self.optionImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.optionImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        
        self.optionTextLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        self.optionTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        self.optionTextLabel.leadingAnchor.constraint(equalTo: optionImageView.trailingAnchor, constant: 5).isActive = true
        self.optionTextLabel.trailingAnchor.constraint(equalTo: playImageView.leadingAnchor, constant: -5).isActive = true
        
        self.playImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.playImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.playImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        self.playImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
    }
    
}
