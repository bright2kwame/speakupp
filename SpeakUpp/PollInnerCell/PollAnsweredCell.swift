//
//  PollAnsweredCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 10/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class PollAnsweredCell: BaseCell {
    
    var feed: PollChoice? {
        didSet {
            guard let unwrapedItem = feed else {return}
            self.optionTextLabel.text = unwrapedItem.choiceText
            self.optionTextLabel.addLabeldecorators()
            self.votePercentTextLabel.text = "\(unwrapedItem.resultPercent) %"
            let fraction = Double(unwrapedItem.resultPercent)!/100
            self.progressUIView.progress = Float(fraction)
            self.indicatorImageView.isHidden = !unwrapedItem.isSelectedOption
        }
    }
    
    let optionTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = ""
        textView.numberOfLines = 0
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.darkText
        return textView
    }()
    
    
    let votePercentTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = ""
        textView.numberOfLines = 0
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.darkText
        return textView
    }()
    
    let progressUIView: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .bar)
        progressBar.progress = 0
        progressBar.trackTintColor = UIColor.white
        progressBar.tintColor = UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.0)
        progressBar.backgroundColor = UIColor.white
        progressBar.layer.borderWidth = 0.4
        progressBar.layer.borderColor = UIColor.lightGray.cgColor
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        return progressBar
    }()
    
    let indicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderWidth = 0
        let image = UIImage(named: "Accept")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override func setUpView() {
        super.setUpView()
        self.backgroundColor = UIColor.white
        addSubview(progressUIView)
        addSubview(optionTextLabel)
        addSubview(votePercentTextLabel)
        addSubview(indicatorImageView)
        
        self.progressUIView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.progressUIView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        self.progressUIView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        self.progressUIView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        self.votePercentTextLabel.trailingAnchor.constraint(equalTo: indicatorImageView.leadingAnchor, constant: -4).isActive = true
        self.votePercentTextLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        self.votePercentTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        self.votePercentTextLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.indicatorImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
        self.indicatorImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        self.indicatorImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        self.indicatorImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.optionTextLabel.trailingAnchor.constraint(equalTo: votePercentTextLabel.leadingAnchor, constant: -8).isActive = true
        self.optionTextLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        self.optionTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        self.optionTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        
    }
}
