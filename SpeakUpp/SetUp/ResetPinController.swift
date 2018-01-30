//
//  ResetPinController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 30/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import Dodo

class ResetPinController: UIViewController {
    
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
    
    let welcomeTextView: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.text = "Hello there,\nReset PIN."
        textView.font = UIFont(name: "RobotoLight", size: 14)
        textView.textColor = UIColor.white
        return textView
    }()
    
    let otpNumberLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = "OTP\nCODE*"
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.5)
        return textView
    }()
    
    lazy var otpTextField: UITextField = {
        let color = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.2)
        let textField = ViewControllerHelper.baseField()
        textField.keyboardType = UIKeyboardType.numberPad
        textField.delegate = self
        textField.attributedPlaceholder =  NSAttributedString(string: "Verification Code",
                                                              attributes: [NSAttributedStringKey.foregroundColor: color])
        return textField
    }()
    
    let otpDividerView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.2)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    
    let pinNumberLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = "4 DIGIT PIN*"
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.5)
        return textView
    }()

    
    lazy var pinTextField: UITextField = {
        let color = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.2)
        let textField = ViewControllerHelper.baseField()
        textField.keyboardType = UIKeyboardType.numberPad
        textField.delegate = self
        textField.attributedPlaceholder =  NSAttributedString(string: "4 Digit Pin",
                                                              attributes: [NSAttributedStringKey.foregroundColor: color])
        return textField
    }()
    
    let pinDividerView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.2)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    
    let pinAgainNumberLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = "CONFRIM\nPIN*"
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.5)
        return textView
    }()
    
    lazy var pinAgainTextField: UITextField = {
        let color = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.2)
        let textField = ViewControllerHelper.baseField()
        textField.keyboardType = UIKeyboardType.numberPad
        textField.delegate = self
        textField.attributedPlaceholder =  NSAttributedString(string: "4 Digit Pin Again",
                                                              attributes: [NSAttributedStringKey.foregroundColor: color])
        return textField
    }()
    
    let pinAgainDividerView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.2)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    let resetPinButton: UIButton = {
        let button = ViewControllerHelper.baseButton()
        let color = UIColor.white
        button.setTitle("Reset PIN", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = color.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()
    
    
    let cancelButton: UIButton = {
        let button = ViewControllerHelper.baseButton()
        let color = UIColor.white
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = color.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        self.setUpView()
        
    }
    
     func setUpView() {
      
        self.view.addSubview(imageView)
        self.view.addSubview(profileImageView)
        self.view.addSubview(welcomeTextView)
        
        self.view.addSubview(otpNumberLabel)
        self.view.addSubview(otpTextField)
        self.view.addSubview(otpDividerView)
        
        self.view.addSubview(pinNumberLabel)
        self.view.addSubview(pinTextField)
        self.view.addSubview(pinDividerView)
        
        self.view.addSubview(pinAgainNumberLabel)
        self.view.addSubview(pinAgainTextField)
        self.view.addSubview(pinAgainDividerView)
        
        
        self.imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        self.profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        self.profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        self.profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.welcomeTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        self.welcomeTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        self.welcomeTextView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 4).isActive = true
        self.welcomeTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        //otp section
        self.otpNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        self.otpNumberLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.otpNumberLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.otpNumberLabel.topAnchor.constraint(equalTo: welcomeTextView.bottomAnchor, constant: 50).isActive = true
        
        self.otpTextField.leadingAnchor.constraint(equalTo: otpNumberLabel.trailingAnchor, constant: 16).isActive = true
        self.otpTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        self.otpTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.otpTextField.topAnchor.constraint(equalTo: welcomeTextView.bottomAnchor, constant: 50).isActive = true
        
        self.otpDividerView.topAnchor.constraint(equalTo: otpNumberLabel.bottomAnchor, constant: 4).isActive = true
        self.otpDividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
        self.otpDividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        self.otpDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        //pin section
        self.pinNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        self.pinNumberLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.pinNumberLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.pinNumberLabel.topAnchor.constraint(equalTo: otpDividerView.bottomAnchor, constant: 16).isActive = true
        
        self.pinTextField.topAnchor.constraint(equalTo: otpDividerView.bottomAnchor, constant: 16).isActive = true
        self.pinTextField.leadingAnchor.constraint(equalTo: pinNumberLabel.trailingAnchor, constant: 4).isActive = true
        self.pinTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        self.pinTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.pinDividerView.topAnchor.constraint(equalTo: pinNumberLabel.bottomAnchor, constant: 4).isActive = true
        self.pinDividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        self.pinDividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        self.pinDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //second pin section
        self.pinAgainNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        self.pinAgainNumberLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.pinAgainNumberLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.pinAgainNumberLabel.topAnchor.constraint(equalTo: pinDividerView.bottomAnchor, constant: 16).isActive = true
        
        self.pinAgainTextField.topAnchor.constraint(equalTo: pinDividerView.bottomAnchor, constant: 16).isActive = true
        self.pinAgainTextField.leadingAnchor.constraint(equalTo: pinAgainNumberLabel.trailingAnchor, constant: 4).isActive = true
        self.pinAgainTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        self.pinAgainTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.pinAgainDividerView.topAnchor.constraint(equalTo: pinAgainNumberLabel.bottomAnchor, constant: 4).isActive = true
        self.pinAgainDividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        self.pinAgainDividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        self.pinAgainDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        //button section
        let codeStack = UIStackView(arrangedSubviews: [cancelButton,resetPinButton])
        codeStack.translatesAutoresizingMaskIntoConstraints = false
        codeStack.distribution = .fillEqually
        codeStack.axis = .horizontal
        codeStack.spacing = 10
        self.view.addSubview(codeStack)
        
        codeStack.topAnchor.constraint(equalTo: pinAgainDividerView.bottomAnchor, constant: 50).isActive = true
        codeStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        codeStack.widthAnchor.constraint(equalToConstant: 200).isActive = true
        codeStack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    @objc private func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ResetPinController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        return true
    }
    
}

