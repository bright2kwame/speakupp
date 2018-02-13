//
//  EventDetailController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 09/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit


class EventDetailController: UIViewController {
    
    var event: Poll?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.alwaysBounceVertical = true
        scrollView.sizeToFit()
        scrollView.contentSize = self.view.bounds.size
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderWidth = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let contentTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = UIColor.darkGray
        return textView
    }()
    
    let dateTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = UIColor.darkGray
        return textView
    }()
    
    let timeTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = UIColor.darkGray
        return textView
    }()
    
    
    let dateDividerView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.groupTableViewBackground
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        self.setUpLayout()
    }
  
    func setUpLayout() {
        self.setUpNavigationBar()
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(eventImageView)
        self.scrollView.addSubview(contentTextLabel)
        self.scrollView.addSubview(dateTextLabel)
        self.scrollView.addSubview(dateDividerView)
        self.scrollView.addSubview(timeTextLabel)
        
        let screenWidth = self.view.frame.width
        self.scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 0).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 0).isActive = true
        self.scrollView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        
        self.eventImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        self.eventImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        self.eventImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        self.eventImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        self.contentTextLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.contentTextLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.contentTextLabel.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: 16).isActive = true
        self.contentTextLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        self.dateTextLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.dateTextLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.dateTextLabel.topAnchor.constraint(equalTo: contentTextLabel.bottomAnchor, constant: 16).isActive = true
        self.dateTextLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        self.dateDividerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.dateDividerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.dateDividerView.topAnchor.constraint(equalTo: dateTextLabel.bottomAnchor, constant: 16).isActive = true
        self.dateDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.timeTextLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.timeTextLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.timeTextLabel.topAnchor.constraint(equalTo: dateDividerView.bottomAnchor, constant: 16).isActive = true
        self.timeTextLabel.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -16).isActive = true
        
        self.updateUI()
    }
    
    func updateUI() {
         guard let unwrapedItem = self.event else {return}
        if  !(unwrapedItem.image.isEmpty) {
            self.eventImageView.af_setImage(
                withURL: URL(string: (unwrapedItem.image))!,
                placeholderImage: Mics.placeHolder(),
                imageTransition: .crossDissolve(0.2)
            )}
        
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)]
        let termsAttributes = [NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
        
        let header = NSMutableAttributedString(string: "\(unwrapedItem.eventTitle)\n\n", attributes: attributes)
        let terms = NSMutableAttributedString(string: "\(unwrapedItem.eventDescription)", attributes: termsAttributes)
        
        let combinedText = NSMutableAttributedString()
        combinedText.append(header)
        combinedText.append(terms)
    
        self.contentTextLabel.textAlignment = .left
        self.contentTextLabel.attributedText = combinedText
        
        
        self.dateTextLabel.text = "Event Date: \(unwrapedItem.eventStartDate.formateAsShortDate())"
        self.timeTextLabel.text = "Event Time: \(unwrapedItem.eventTime)"
       
    }

    private func setUpNavigationBar()  {
        navigationItem.title = "Event Detail"
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let image = UIImage(named: "BackArrow")?.withRenderingMode(.alwaysOriginal)
        let menuBack = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = menuBack
    }
    
    @objc func handleCancel()  {
        self.navigationController?.popViewController(animated: true)
    }
}
