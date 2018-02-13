//
//  SettingController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 30/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class SettingController: UIViewController {
    
    let buttonHeight = CGFloat(30.0)
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "UserIcon")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = "*****"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.darkGray
        return textView
    }()
    
    lazy var profileView: UIView = {
        let uiView = basicView()
        return uiView
    }()
    
    let activityLogButton: UIButton = {
        let button = ViewControllerHelper.plainButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("Activity Log", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(handleActivityLog), for: .touchUpInside)
        return button
    }()
    
    lazy var activityView: UIView = {
        let uiView = basicView()
        return uiView
    }()
    
    let notificationButton: UIButton = {
        let button = ViewControllerHelper.plainButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("Notifications", for: .normal)
        button.layer.cornerRadius = 0
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(handleActivityLog), for: .touchUpInside)
        return button
    }()
    
    lazy var notificationView: UIView = {
        let uiView = basicView()
        return uiView
    }()
    
    
    let soundButton: UIButton = {
        let button = ViewControllerHelper.plainButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("Sound", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(handleActivityLog), for: .touchUpInside)
        return button
    }()
    
    lazy var soundView: UIView = {
        let uiView = basicView()
        return uiView
    }()
    
    let privacyButton: UIButton = {
        let button = ViewControllerHelper.plainButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("Privacy", for: .normal)
        button.layer.cornerRadius = 0
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(handleActivityLog), for: .touchUpInside)
        return button
    }()
    
    lazy var privacyView: UIView = {
        let uiView = basicView()
        return uiView
    }()
    
    let shareButton: UIButton = {
        let button = ViewControllerHelper.plainButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("Tell a Friend", for: .normal)
        button.layer.cornerRadius = 0
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(handleActivityLog), for: .touchUpInside)
        return button
    }()
    
    lazy var shareView: UIView = {
        let uiView = basicView()
        return uiView
    }()
    
    let contactButton: UIButton = {
        let button = ViewControllerHelper.plainButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("Contact Us", for: .normal)
        button.layer.cornerRadius = 0
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(handleActivityLog), for: .touchUpInside)
        return button
    }()
    
    lazy var contactView: UIView = {
        let uiView = basicView()
        return uiView
    }()
    
    let faqButton: UIButton = {
        let button = ViewControllerHelper.plainButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("FAQs", for: .normal)
        button.layer.cornerRadius = 0
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(handleActivityLog), for: .touchUpInside)
        return button
    }()
    
    lazy var faqView: UIView = {
        let uiView = basicView()
        return uiView
    }()
    

    func basicView() -> UIView {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.gray
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }
    
    override func viewDidLoad() {
        self.setUpView()
    }
    
    func setUpView() {
        self.setUpNavigationBar()
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(profileImageView)
        self.scrollView.addSubview(nameLabel)
        self.scrollView.addSubview(profileView)
        self.scrollView.addSubview(activityLogButton)
        self.scrollView.addSubview(activityView)
        self.scrollView.addSubview(notificationButton)
        self.scrollView.addSubview(notificationView)
        self.scrollView.addSubview(soundButton)
        self.scrollView.addSubview(soundView)
        self.scrollView.addSubview(privacyButton)
        self.scrollView.addSubview(privacyView)
        self.scrollView.addSubview(shareButton)
        self.scrollView.addSubview(shareView)
        self.scrollView.addSubview(contactButton)
        self.scrollView.addSubview(contactView)
        self.scrollView.addSubview(faqButton)
        self.scrollView.addSubview(faqView)
        
        let width = self.scrollView.frame.width
        self.scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 0).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 0).isActive = true
        
        self.profileImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
       
        self.profileView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        self.profileView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        self.profileView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16).isActive = true
        self.profileView.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        self.activityLogButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        //self.activityLogButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.activityLogButton.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 16).isActive = true
        self.activityLogButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        self.activityLogButton.widthAnchor.constraint(equalToConstant: width-32).isActive = true
        
        self.activityView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        self.activityView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        self.activityView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        self.activityView.topAnchor.constraint(equalTo: activityLogButton.bottomAnchor, constant: 16).isActive = true
        self.activityView.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        self.notificationButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        //self.notificationButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.notificationButton.topAnchor.constraint(equalTo: activityView.bottomAnchor, constant: 16).isActive = true
        self.notificationButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        self.notificationButton.widthAnchor.constraint(equalToConstant: width-32).isActive = true
        
        self.notificationView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        self.notificationView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        self.notificationView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        self.notificationView.topAnchor.constraint(equalTo: notificationButton.bottomAnchor, constant: 16).isActive = true
        
        self.soundButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        self.soundButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.soundButton.topAnchor.constraint(equalTo: notificationView.bottomAnchor, constant: 16).isActive = true
        self.soundButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        self.soundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        self.soundView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        self.soundView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        self.soundView.topAnchor.constraint(equalTo: soundButton.bottomAnchor, constant: 16).isActive = true
        
        self.privacyButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        self.privacyButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.privacyButton.topAnchor.constraint(equalTo: soundView.bottomAnchor, constant: 16).isActive = true
        self.privacyButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        self.privacyView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        self.privacyView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        self.privacyView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        self.privacyView.topAnchor.constraint(equalTo: privacyButton.bottomAnchor, constant: 16).isActive = true
        
        self.shareButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        self.shareButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.shareButton.topAnchor.constraint(equalTo: privacyView.bottomAnchor, constant: 16).isActive = true
        self.shareButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        self.shareView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        self.shareView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        self.shareView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        self.shareView.topAnchor.constraint(equalTo: shareButton.bottomAnchor, constant: 16).isActive = true
        
        self.contactButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        self.contactButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.contactButton.topAnchor.constraint(equalTo: shareView.bottomAnchor, constant: 16).isActive = true
        self.contactButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        self.contactView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        self.contactView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        self.contactView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        self.contactView.topAnchor.constraint(equalTo: contactButton.bottomAnchor, constant: 16).isActive = true
        
        self.faqButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        self.faqButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.faqButton.topAnchor.constraint(equalTo: contactView.bottomAnchor, constant: 16).isActive = true
        self.faqButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        self.faqView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        self.faqView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        self.faqView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        self.faqView.topAnchor.constraint(equalTo: faqButton.bottomAnchor, constant: 16).isActive = true
        
        self.setUpUIElements()
    }
    
    func setUpUIElements()  {
        if let user = User.getUser() {
            self.profileImageView.af_setImage(
                withURL: URL(string: (user.profile))!,
                placeholderImage: Mics.userPlaceHolder(),
                imageTransition: .crossDissolve(0.2)
            )
            self.nameLabel.text = user.fullName
        }
    }
    
    private func setUpNavigationBar()  {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.isTranslucent = false
    
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        
        let image = UIImage(named: "BackArrow")?.withRenderingMode(.alwaysOriginal)
        let menuBack = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = menuBack
    }

    @objc func handleCancel()  {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleActivityLog()  {
        dismiss(animated: true, completion: nil)
    }
}
