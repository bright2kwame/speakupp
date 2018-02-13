//
//  LoginController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 23/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import ADCountryPicker
import Dodo




class LoginController: UIViewController {
    
    let apiService = ApiService()
    let utilController = ViewControllerHelper()
    
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
        textView.text = "Hello again,\nWelcome back."
        textView.font = UIFont(name: "RobotoLight", size: 14)
        textView.textColor = UIColor.white
        return textView
    }()
    
    let phoneNumberLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = "PHONE\nNUMBER"
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
    
    let pinNumberLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = "4 DIGIT PIN"
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.5)
        return textView
    }()
    
    let pinDividerView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.2)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var pinTextField: UITextField = {
        let color = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 0.2)
        let textField = ViewControllerHelper.baseField()
        textField.keyboardType = UIKeyboardType.numberPad
        textField.delegate = self
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder =  NSAttributedString(string: "4 Digit Pin",
                                                              attributes: [NSAttributedStringKey.foregroundColor: color])
        return textField
    }()
    
    
    let loginButton: UIButton = {
        let button = ViewControllerHelper.baseButton()
        let color = UIColor.white
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = color.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
        
    }
    
    
    func setUpViews()  {
        
        self.view.addSubview(imageView)
        self.view.addSubview(closeImageView)
        self.view.addSubview(profileImageView)
        self.view.addSubview(welcomeTextView)
        self.view.addSubview(privacyLabel)
        self.view.addSubview(phoneNumberLabel)
        self.view.addSubview(countryButton)
        self.view.addSubview(uiView)
        self.view.addSubview(numberDividerView)
        self.view.addSubview(numberTextField)
        self.view.addSubview(pinNumberLabel)
        self.view.addSubview(pinDividerView)
        self.view.addSubview(pinTextField)
        self.view.addSubview(loginButton)
        
        self.imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        self.closeImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        self.closeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        self.closeImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.closeImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        let tappedAction = UITapGestureRecognizer(target: self, action: #selector(LoginController.closeAction(gesture:)))
        self.closeImageView.addGestureRecognizer(tappedAction)
        
        self.profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        self.profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        self.profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: closeImageView.bottomAnchor, constant: 20).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
       
        self.welcomeTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        self.welcomeTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        self.welcomeTextView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 4).isActive = true
        self.welcomeTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
      
        self.phoneNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        self.phoneNumberLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.phoneNumberLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.phoneNumberLabel.topAnchor.constraint(equalTo: welcomeTextView.bottomAnchor, constant: 20).isActive = true
        
        self.countryButton.leadingAnchor.constraint(equalTo: phoneNumberLabel.trailingAnchor, constant: 16).isActive = true
        self.countryButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.countryButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.countryButton.topAnchor.constraint(equalTo: welcomeTextView.bottomAnchor, constant: 20).isActive = true
      
        self.numberDividerView.topAnchor.constraint(equalTo: welcomeTextView.bottomAnchor, constant: 25).isActive = true
        self.numberDividerView.leadingAnchor.constraint(equalTo: countryButton.trailingAnchor, constant: 4).isActive = true
        self.numberDividerView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        self.numberDividerView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.numberTextField.topAnchor.constraint(equalTo: welcomeTextView.bottomAnchor, constant: 20).isActive = true
        self.numberTextField.leadingAnchor.constraint(equalTo: numberDividerView.trailingAnchor, constant: 4).isActive = true
        self.numberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        self.numberTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.uiView.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 4).isActive = true
        self.uiView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        self.uiView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        self.uiView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.pinNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        self.pinNumberLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.pinNumberLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.pinNumberLabel.topAnchor.constraint(equalTo: uiView.bottomAnchor, constant: 16).isActive = true
        
        self.pinTextField.topAnchor.constraint(equalTo: uiView.bottomAnchor, constant: 16).isActive = true
        self.pinTextField.leadingAnchor.constraint(equalTo: pinNumberLabel.trailingAnchor, constant: 4).isActive = true
        self.pinTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        self.pinTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.pinDividerView.topAnchor.constraint(equalTo: pinNumberLabel.bottomAnchor, constant: 4).isActive = true
        self.pinDividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        self.pinDividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        self.pinDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.loginButton.topAnchor.constraint(equalTo: pinDividerView.bottomAnchor, constant: 50).isActive = true
        self.loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.loginButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.privacyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        self.privacyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        self.privacyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.privacyLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true

    }
    
    
    @objc private func login() {
       let numberCode = countryButton.currentTitle!.split(separator: " ")[1]
       let number =  numberTextField.text!
       let pin = pinTextField.text!
        
        if (number.isEmpty) {
            ViewControllerHelper.showAlert(vc: self, message: "Number is required", type: .failed)
            return
        }
    
        if (pin.isEmpty) {
            ViewControllerHelper.showAlert(vc: self, message: "Enter a valid PIN", type: .failed)
            return
        }
        
        let realNumber = "\(numberCode)\(number)"
        print("\(realNumber)")
        self.utilController.showActivityIndicator()
        self.apiService.login(number: realNumber, pin: pin) { (status, message) in
            self.utilController.hideActivityIndicator()
            if status != ApiCallStatus.SUCCESS {
                let appearance = SCLAlertView.SCLAppearance(dynamicAnimatorActive: true)
                SCLAlertView(appearance: appearance).showError("SpeakUpp Error", subTitle: message)
            }  else {
                let home = HomeController()
                let drawer = ViewControllerHelper.startHome(controller: home)
                home.homeDrawerController = drawer
                self.present(drawer, animated: true, completion: nil)
            }
        }
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
    
    @objc private func tapLabel(gesture: UITapGestureRecognizer) {
        print("Tapped")
    }
    
    @objc private func closeAction(gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LoginController : UITextFieldDelegate,ADCountryPickerDelegate {
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



