//
//  SignUpVerificationController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 26/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class SignUpVerificationController: UIViewController {
    
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
        imageView.image = UIImage(named: "LogoImage")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let contentView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.white
        uiView.layer.cornerRadius = 5
        uiView.layer.masksToBounds = true
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    let messageLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)]
        let termsAttributes = [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]
        
        let header = NSMutableAttributedString(string: "Verify Phone Number\n\n", attributes: attributes)
        let terms = NSMutableAttributedString(string: "A verification code will be sent to your phone number. Enter the code to verify and proceed.", attributes: termsAttributes)
        
        let combinedText = NSMutableAttributedString()
        combinedText.append(header)
        combinedText.append(terms)
        
        
        textView.textAlignment = .center
        textView.attributedText = combinedText
        textView.isUserInteractionEnabled = true

        return textView
    }()
    
    
    let nextButton: UIButton = {
        let button = ViewControllerHelper.baseButton()
        let color = UIColor.white
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 0
        button.layer.borderWidth = 0
        button.layer.borderColor = color.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.setTitleColor(UIColor.hex(hex: Key.primaryHexCode), for: .normal)
        button.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpViews()
    }
    
    @objc private func goNext() {
       self.present(VerificationCodeController(), animated: true, completion: nil)
    }
    
    func setUpViews()  {
        
        self.view.addSubview(imageView)
        self.view.addSubview(profileImageView)
        self.view.addSubview(contentView)
        self.contentView.addSubview(messageLabel)
        self.contentView.addSubview(nextButton)
  
        self.imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        self.profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50).isActive = true
        self.profileImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50).isActive = true
        self.profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        self.contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        self.contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.contentView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 100).isActive = true
        self.contentView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50).isActive = true
        self.messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
        self.messageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        self.messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        self.messageLabel.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: 8).isActive = true
        
        self.nextButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50).isActive = true
        self.nextButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
        self.nextButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        self.nextButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
}
