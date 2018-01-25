//
//  SignUpController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 25/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import ADCountryPicker
import Dodo
import DLRadioButton
import ActionSheetPicker_3_0

class SignUpController: UIViewController {
    let labelWidth = CGFloat(100)
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppBg")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let closeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CloseCross")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
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
        textView.text = "Hello!\nSign up to get started."
        textView.font = UIFont(name: "RobotoLight", size: 14)
        textView.textColor = UIColor.white
        return textView
    }()
    
    
    let nameLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = "FULL NAME*"
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.5)
        return textView
    }()
    
    lazy var nameTextField: UITextField = {
        let color = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.2)
        let textField = ViewControllerHelper.baseField()
        textField.keyboardType = UIKeyboardType.alphabet
        textField.attributedPlaceholder =  NSAttributedString(string: "Full Name",
                                                              attributes: [NSAttributedStringKey.foregroundColor: color])
        return textField
    }()
    
    let nameUnderlineView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.2)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    let phoneNumberLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = "PHONE\nNUMBER*"
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.5)
        return textView
    }()
    
    let countryButton: UIButton = {
        let button = ViewControllerHelper.plainButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        let text = Mics.flag(country: "GH")
        button.setTitle("\(text) +233", for: .normal)
        button.layer.cornerRadius = 0
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(pickCountry), for: .touchUpInside)
        return button
    }()
    
    let uiView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.2)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    let numberDividerView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.2)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var numberTextField: UITextField = {
        let color = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.2)
        let textField = ViewControllerHelper.baseField()
        textField.keyboardType = UIKeyboardType.numberPad
        textField.delegate = self
        textField.attributedPlaceholder =  NSAttributedString(string: "Phone Number",
                                                              attributes: [NSAttributedStringKey.foregroundColor: color])
        return textField
    }()
    
    
    let genderLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = "GENDER*"
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.5)
        return textView
    }()
    
    lazy var maleButton: DLRadioButton = {
        let radioButton = self.createRadioButton(title : "Male", color : UIColor.white)
        radioButton.addTarget(self, action: #selector(LogSelectedButton), for: UIControlEvents.touchUpInside)
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        return radioButton
    }()
    
    lazy var feMaleButton: DLRadioButton = {
        let radioButton = self.createRadioButton(title : "Female", color : UIColor.white)
        radioButton.addTarget(self, action: #selector(LogSelectedButton), for: UIControlEvents.touchUpInside)
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        return radioButton
    }()
    
    private func createRadioButton(title : String, color : UIColor) -> DLRadioButton {
        let radioButton = DLRadioButton()
        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        radioButton.setTitle(title, for: []);
        radioButton.setTitleColor(color, for: [])
        radioButton.iconColor = color
        radioButton.indicatorColor = color
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        return radioButton
    }
    
    let genderUnderlineView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.2)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    let dateOfBirthLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = "BIRTHDAY\n(Age 16+)*"
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.5)
        return textView
    }()
    
    let datePickerButton: UIButton = {
        let button = ViewControllerHelper.plainButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("Choose Birthday", for: .normal)
        button.layer.cornerRadius = 0
        button.setTitleColor(UIColor.white, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(dateAndTime), for: .touchUpInside)
        return button
    }()
    
    let dateUnderlineView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.2)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    let pinLabel: UILabel = {
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
        textField.delegate = self
        textField.keyboardType = UIKeyboardType.numberPad
        textField.attributedPlaceholder =  NSAttributedString(string: "4 Digit Pin",
                                                              attributes: [NSAttributedStringKey.foregroundColor: color])
        return textField
    }()
    
    let pinUnderlineView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.2)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    let confirmPinLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = "PIN\nCONFIRMATION*"
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.5)
        return textView
    }()
    
    lazy var confirmPinTextField: UITextField = {
        let color = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.2)
        let textField = ViewControllerHelper.baseField()
        textField.delegate = self
        textField.keyboardType = UIKeyboardType.numberPad
        textField.attributedPlaceholder =  NSAttributedString(string: "Confirm 4 Digit Pin",
                                                              attributes: [NSAttributedStringKey.foregroundColor: color])
        return textField
    }()
    
    let confirmPinUnderlineView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.2)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    
    let signUpButton: UIButton = {
        let button = ViewControllerHelper.baseButton()
        let color = UIColor.white
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = color.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        return button
    }()
    
    
    
    
    let privacyLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
        let termsAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12)]
        
        let header = NSMutableAttributedString(string: "By continuing you indicate that you have read and agree to the\n", attributes: attributes)
        let terms = NSMutableAttributedString(string: "Terms of Service.", attributes: termsAttributes)
        
        let combinedText = NSMutableAttributedString()
        combinedText.append(header)
        combinedText.append(terms)
        
        
        textView.textAlignment = .center
        textView.attributedText = combinedText
        textView.textColor = UIColor.white
        textView.isUserInteractionEnabled = true
        
        let tappedName = UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:)))
        textView.addGestureRecognizer(tappedName)
        return textView
    }()
    
    override func viewDidLoad() {
       super.viewDidLoad()
    
       self.setUpViews()
        
        
    }
    
    func setUpViews()  {
        
        
        self.view.addSubview(imageView)
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(closeImageView)
        self.scrollView.addSubview(profileImageView)
        self.scrollView.addSubview(welcomeTextView)
        self.scrollView.addSubview(nameLabel)
        self.scrollView.addSubview(nameUnderlineView)
        self.scrollView.addSubview(nameTextField)
        self.scrollView.addSubview(phoneNumberLabel)
        self.scrollView.addSubview(numberTextField)
        self.scrollView.addSubview(countryButton)
        self.scrollView.addSubview(uiView)
        self.scrollView.addSubview(numberDividerView)
        self.scrollView.addSubview(genderLabel)
        self.scrollView.addSubview(genderUnderlineView)
        self.scrollView.addSubview(maleButton)
        self.scrollView.addSubview(feMaleButton)
        self.scrollView.addSubview(dateOfBirthLabel)
        self.scrollView.addSubview(datePickerButton)
        self.scrollView.addSubview(dateUnderlineView)
        
        self.scrollView.addSubview(pinLabel)
        self.scrollView.addSubview(pinTextField)
        self.scrollView.addSubview(pinUnderlineView)
        self.scrollView.addSubview(confirmPinLabel)
        self.scrollView.addSubview(confirmPinTextField)
        self.scrollView.addSubview(confirmPinUnderlineView)
        self.scrollView.addSubview(signUpButton)
        self.scrollView.addSubview(privacyLabel)
        
       
        
        self.imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        self.scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 0).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 0).isActive = true
        
        self.closeImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        self.closeImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.closeImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        self.closeImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        let tappedAction = UITapGestureRecognizer(target: self, action: #selector(SignUpController.closeAction(gesture:)))
        self.closeImageView.addGestureRecognizer(tappedAction)
        
        self.profileImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 50).isActive = true
        self.profileImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -50).isActive = true
        self.profileImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: closeImageView.bottomAnchor, constant: 20).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.welcomeTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 30).isActive = true
        self.welcomeTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -50).isActive = true
        self.welcomeTextView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 4).isActive = true
        self.welcomeTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        //MARK -- name section
        self.nameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.nameLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        self.nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: welcomeTextView.bottomAnchor, constant: 40).isActive = true
        
        self.nameTextField.topAnchor.constraint(equalTo: welcomeTextView.bottomAnchor, constant: 40).isActive = true
        self.nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 4).isActive = true
        self.nameTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.nameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.nameUnderlineView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        self.nameUnderlineView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.nameUnderlineView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.nameUnderlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        //MARK - phone number section
        self.phoneNumberLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.phoneNumberLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        self.phoneNumberLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.phoneNumberLabel.topAnchor.constraint(equalTo: nameUnderlineView.bottomAnchor, constant: 16).isActive = true
        
        self.countryButton.leadingAnchor.constraint(equalTo: phoneNumberLabel.trailingAnchor, constant: 16).isActive = true
        self.countryButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.countryButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.countryButton.topAnchor.constraint(equalTo: nameUnderlineView.bottomAnchor, constant: 16).isActive = true
        
        self.numberDividerView.topAnchor.constraint(equalTo: nameUnderlineView.bottomAnchor, constant: 20).isActive = true
        self.numberDividerView.leadingAnchor.constraint(equalTo: countryButton.trailingAnchor, constant: 4).isActive = true
        self.numberDividerView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        self.numberDividerView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.numberTextField.topAnchor.constraint(equalTo: nameUnderlineView.bottomAnchor, constant: 16).isActive = true
        self.numberTextField.leadingAnchor.constraint(equalTo: numberDividerView.trailingAnchor, constant: 4).isActive = true
        self.numberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        self.numberTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.uiView.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 4).isActive = true
        self.uiView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        self.uiView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        self.uiView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //MARK - gender section
        self.genderLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.genderLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        self.genderLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.genderLabel.topAnchor.constraint(equalTo: uiView.bottomAnchor, constant: 16).isActive = true
        
        self.maleButton.topAnchor.constraint(equalTo: uiView.bottomAnchor, constant: 25).isActive = true
        self.maleButton.leadingAnchor.constraint(equalTo: genderLabel.trailingAnchor, constant: 4).isActive = true
        self.maleButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.maleButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.feMaleButton.topAnchor.constraint(equalTo: uiView.bottomAnchor, constant: 25).isActive = true
        self.feMaleButton.leadingAnchor.constraint(equalTo: maleButton.trailingAnchor, constant: 4).isActive = true
        self.feMaleButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.feMaleButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.genderUnderlineView.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 4).isActive = true
        self.genderUnderlineView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.genderUnderlineView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.genderUnderlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
      
        //MARK - date of birth section
        self.dateOfBirthLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.dateOfBirthLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        self.dateOfBirthLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.dateOfBirthLabel.topAnchor.constraint(equalTo: genderUnderlineView.bottomAnchor, constant: 16).isActive = true
        
        self.datePickerButton.topAnchor.constraint(equalTo: genderUnderlineView.bottomAnchor, constant: 16).isActive = true
        self.datePickerButton.leadingAnchor.constraint(equalTo: dateOfBirthLabel.trailingAnchor, constant: 4).isActive = true
        self.datePickerButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.datePickerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.dateUnderlineView.topAnchor.constraint(equalTo: dateOfBirthLabel.bottomAnchor, constant: 4).isActive = true
        self.dateUnderlineView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.dateUnderlineView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.dateUnderlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        //MARK - the pin section
        self.pinLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.pinLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        self.pinLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.pinLabel.topAnchor.constraint(equalTo: dateUnderlineView.bottomAnchor, constant: 16).isActive = true
        
        self.pinTextField.topAnchor.constraint(equalTo: dateUnderlineView.bottomAnchor, constant: 16).isActive = true
        self.pinTextField.leadingAnchor.constraint(equalTo: pinLabel.trailingAnchor, constant: 4).isActive = true
        self.pinTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.pinTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.pinUnderlineView.topAnchor.constraint(equalTo: pinLabel.bottomAnchor, constant: 4).isActive = true
        self.pinUnderlineView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.pinUnderlineView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.pinUnderlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //MARK - the confirm pin section
        self.confirmPinLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.confirmPinLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        self.confirmPinLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.confirmPinLabel.topAnchor.constraint(equalTo: pinUnderlineView.bottomAnchor, constant: 16).isActive = true
        
        self.confirmPinTextField.topAnchor.constraint(equalTo: pinUnderlineView.bottomAnchor, constant: 16).isActive = true
        self.confirmPinTextField.leadingAnchor.constraint(equalTo: confirmPinLabel.trailingAnchor, constant: 4).isActive = true
        self.confirmPinTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.confirmPinTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.confirmPinUnderlineView.topAnchor.constraint(equalTo: confirmPinLabel.bottomAnchor, constant: 4).isActive = true
        self.confirmPinUnderlineView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.confirmPinUnderlineView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.confirmPinUnderlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //MARK - button section
        self.signUpButton.topAnchor.constraint(equalTo: confirmPinUnderlineView.bottomAnchor, constant: 50).isActive = true
        self.signUpButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        self.signUpButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.signUpButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //MARK - privacy section
        self.privacyLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.privacyLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.privacyLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        self.privacyLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 100).isActive = true
        
        
    }
    
    @objc private func signUp() {
        let number =  numberTextField.text
        let pin = pinTextField.text
        
    }
    
    @objc private func closeAction(gesture: UITapGestureRecognizer) {
        print("CALLED")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func tapLabel(gesture: UITapGestureRecognizer) {
        print("Tapped")
    }
    
    @objc private func pickCountry() {
        let picker = ADCountryPicker()
        picker.delegate = self
        picker.showCallingCodes = true
        picker.showFlags = true
        picker.pickerTitle = "Select a Country"
        picker.defaultCountryCode = "GH"
        picker.alphabetScrollBarTintColor = UIColor.black
        picker.alphabetScrollBarBackgroundColor = UIColor.clear
        picker.closeButtonTintColor = UIColor.white
        picker.font = UIFont(name: "RobotoLight", size: 14)
        picker.flagHeight = 40
        picker.hidesNavigationBarWhenPresentingSearch = true
        picker.searchBarBackgroundColor = UIColor.hex(hex: Key.primaryHexCode)
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        self.present(pickerNavigationController, animated: true, completion: nil)
    }
    
    @objc private func pickDate() {
        
    }
   
    @objc private func LogSelectedButton(radioButton : DLRadioButton) {
        let text =  radioButton.selected()!.titleLabel!.text!
        if text == "Male" {
            feMaleButton.isSelected = false
         }  else {
           maleButton.isSelected = false
        }
    }
    
    @objc func dateAndTime(_ sender: UIButton) {
        let sixteenInterval: TimeInterval = 17 * 12 * 4 * 7 * 24 * 60 * 60
        let startingDate = Date(timeInterval: -sixteenInterval, since: Date())
        let datePicker = ActionSheetDatePicker(title: "Select Birthday", datePickerMode: UIDatePickerMode.date, selectedDate: startingDate, doneBlock: {
            picker, value, index in
            //let dateFormatterGet = DateFormatter()
            //dateFormatterGet.dateFormat = "yyyy-MM-dd hh:mm:ss"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd,yyyy"
            let displayDate = dateFormatterPrint.string(from: value! as! Date)
            self.datePickerButton.setTitle(displayDate, for: .normal)
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!.superview)
        let secondsInWeek: TimeInterval = NSTimeIntervalSince1970
        datePicker?.minimumDate = Date(timeInterval: -secondsInWeek, since: Date())
        datePicker?.maximumDate = Date(timeInterval: -sixteenInterval, since: Date())
        
        datePicker?.show()
    }
    
}

extension SignUpController : UITextFieldDelegate,ADCountryPickerDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        return true
    }
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String) {
        
    }
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        let text = Mics.flag(country: code) + dialCode
        self.countryButton.setTitle(text, for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}

