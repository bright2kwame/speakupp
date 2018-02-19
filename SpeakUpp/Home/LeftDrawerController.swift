//
//  LeftDrawerController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 27/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import ZKDrawerController
import AlamofireImage


class LeftDrawerController: UIViewController {
    
    var homeDrawerController: ZKDrawerController!
    var homeController: HomeController?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.alwaysBounceVertical = true
        scrollView.sizeToFit()
        scrollView.contentSize = self.view.bounds.size
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    //MARK - UI element configurations
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppBg")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    let nameButton: UIButton = {
        let button = ViewControllerHelper.plainButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("----", for: .normal)
        button.layer.cornerRadius = 0
        button.setTitleColor(UIColor.white, for: .normal)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(tappedAccount), for: .touchUpInside)
        return button
    }()
    
    let profileDividerView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.2)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    let homeButton: UIButton = {
        let button = ViewControllerHelper.plainButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("Home", for: .normal)
        button.layer.cornerRadius = 0
        button.setTitleColor(UIColor.white, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(tappedHome), for: .touchUpInside)
        return button
    }()
    
    let trendingButton: UIButton = {
        let button = ViewControllerHelper.plainButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("Trending", for: .normal)
        button.layer.cornerRadius = 0
        button.setTitleColor(UIColor.white, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(tappedTrending), for: .touchUpInside)
        return button
    }()
    
    
    let eventsButton: UIButton = {
        let button = ViewControllerHelper.plainButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("Events", for: .normal)
        button.layer.cornerRadius = 0
        button.setTitleColor(UIColor.white, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(tappedEvents), for: .touchUpInside)
        return button
    }()
    
    let qrCodeButton: UIButton = {
        let button = ViewControllerHelper.plainButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("QR Code Scanner", for: .normal)
        button.layer.cornerRadius = 0
        button.setTitleColor(UIColor.white, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(tappedQrScanner), for: .touchUpInside)
        return button
    }()
    
    let inviteButton: UIButton = {
        let button = ViewControllerHelper.plainButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("Invite Friends", for: .normal)
        button.layer.cornerRadius = 0
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(tappedInvite), for: .touchUpInside)
        return button
    }()
    
    let logoOutButton: UIButton = {
        let button = ViewControllerHelper.plainButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("LOGOUT", for: .normal)
        button.layer.cornerRadius = 0
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(logOutSection), for: .touchUpInside)
        return button
    }()
    
    let settingButton: UIButton = {
        let button = ViewControllerHelper.plainButton()
        let settingImage = UIImage(named: "Settings")
        button.setImage(settingImage, for: .normal)
        button.layer.cornerRadius = 0
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(tappedSetting), for: .touchUpInside)
        return button
    }()
    
    

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clear
        
        self.view.addSubview(imageView)
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(profileImageView)
        self.scrollView.addSubview(nameButton)
        self.scrollView.addSubview(profileDividerView)
        self.scrollView.addSubview(homeButton)
        self.scrollView.addSubview(trendingButton)
        self.scrollView.addSubview(eventsButton)
        self.scrollView.addSubview(inviteButton)
        self.scrollView.addSubview(qrCodeButton)
        
        //MARK - lower section
        self.view.addSubview(logoOutButton)
        self.view.addSubview(settingButton)
        
        
        self.imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        self.imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        
        self.scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 0).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: logoOutButton.bottomAnchor,constant: -16).isActive = true
       
        self.profileImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.nameButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        self.nameButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16).isActive = true
        self.nameButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.nameButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
       
        
        self.profileDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.profileDividerView.topAnchor.constraint(equalTo: nameButton.bottomAnchor, constant: 16).isActive = true
        self.profileDividerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        self.profileDividerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        
        //MARK - menu sections
        self.homeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.homeButton.topAnchor.constraint(equalTo: profileDividerView.bottomAnchor, constant: 20).isActive = true
        self.homeButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.homeButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        
        self.trendingButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.trendingButton.topAnchor.constraint(equalTo: homeButton.bottomAnchor, constant: 16).isActive = true
        self.trendingButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.trendingButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        
        self.eventsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.eventsButton.topAnchor.constraint(equalTo: trendingButton.bottomAnchor, constant: 16).isActive = true
        self.eventsButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.eventsButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        
        self.inviteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.inviteButton.topAnchor.constraint(equalTo: eventsButton.bottomAnchor, constant: 16).isActive = true
        self.inviteButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.inviteButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        

        self.qrCodeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.qrCodeButton.topAnchor.constraint(equalTo: inviteButton.bottomAnchor, constant: 16).isActive = true
        self.qrCodeButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.qrCodeButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.qrCodeButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16).isActive = true
        //end of section
        
        self.logoOutButton.trailingAnchor.constraint(equalTo: settingButton.leadingAnchor, constant: -8).isActive = true
        self.logoOutButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.logoOutButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        self.logoOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        
        self.settingButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.settingButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.settingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        self.settingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        
        self.updateUI()
    }
    
    
    func updateUI()  {
        let user = User.getUser()!
        self.nameButton.setTitle(user.fullName, for: .normal)
    
        if  !(user.profile.isEmpty) {
                self.profileImageView.af_setImage(
                    withURL: URL(string: (user.profile))!,
                    placeholderImage: Mics.placeHolder(),
                    imageTransition: .crossDissolve(0.2)
        )}
        
    }
    
    //MARK - Action on the buttons
    @objc private func tappedTrending() {
        self.homeDrawerController.hide(animated: true)
        self.homeController?.scrollBothToMenuIndex(menuIndex: 1)
    }
    
    @objc private func tappedHome() {
        self.homeDrawerController.hide(animated: true)
        self.homeController?.scrollBothToMenuIndex(menuIndex: 0)
    }
    
    @objc private func tappedQrScanner() {
        self.homeDrawerController.hide(animated: true)
        let nav = UINavigationController(rootViewController: ScannerViewController())
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc private func tappedEvents() {
        self.homeDrawerController.hide(animated: true)
        self.homeController?.scrollBothToMenuIndex(menuIndex: 2)
    }
    
    @objc private func tappedInvite() {
        self.homeDrawerController.hide(animated: true)
        let nav = UINavigationController(rootViewController: InviteController())
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc private func tappedAccount() {
        self.homeDrawerController.hide(animated: true)
        let nav = UINavigationController(rootViewController: SettingController())
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc private func tappedSetting() {
        self.homeDrawerController.hide(animated: true)
        let nav = UINavigationController(rootViewController: SettingController())
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc private func logOutSection() {
        self.homeDrawerController.hide(animated: true)
        self.present(LogoOutController(), animated: true, completion: nil)
    }
}
