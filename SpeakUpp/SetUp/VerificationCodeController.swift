//
//  VerificationCodeController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 27/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class VerificationCodeController: UIViewController {
    
    let apiService = ApiService()
    let phoneNumber = User.getUser()!.number
    let utilController = ViewControllerHelper()
    
    
    lazy var firstCodeTextField: UITextField = {
        return baseInnerField()
    }()
    
    lazy var secondCodeTextField: UITextField = {
        return baseInnerField()
    }()
    
    lazy var thirdCodeTextField: UITextField = {
        return baseInnerField()
    }()
    
    lazy var fourthCodeTextField: UITextField = {
        return baseInnerField()
    }()
    
    lazy var fithCodeTextField: UITextField = {
        return baseInnerField()
    }()
    
    lazy var sixCodeTextField: UITextField = {
        return baseInnerField()
    }()
    
    
    func baseInnerField() -> UITextField {
        let color = UIColor.darkGray
        let textField = ViewControllerHelper.mainBaseField(placeHolder: "")
        textField.delegate = self
        textField.textColor = color
        textField.keyboardType = UIKeyboardType.numberPad
        textField.setBottomBorder()
        textField.textAlignment = .center
        textField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        return textField
    }
    
    lazy var messageLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)]
        let termsAttributes = [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]
        
        let header = NSMutableAttributedString(string: "Enter the code sent to \n\n\(phoneNumber)\n\n", attributes: attributes)
        let terms = NSMutableAttributedString(string: "Please enter the verification code you received from SpeakUpp to proceed.", attributes: termsAttributes)
        
        let combinedText = NSMutableAttributedString()
        combinedText.append(header)
        combinedText.append(terms)
        
        
        textView.textAlignment = .center
        textView.attributedText = combinedText
        textView.isUserInteractionEnabled = true
        
        return textView
    }()
    
    let resendCodeButton: UIButton = {
        let button = ViewControllerHelper.baseButton()
        let color = UIColor.white
        button.setTitle("Resend Code", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 0
        button.layer.borderWidth = 0
        button.layer.borderColor = color.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.setTitleColor(UIColor.hex(hex: Key.primaryHexCode), for: .normal)
        button.addTarget(self, action: #selector(resendCode), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        self.setUpLayout()
    }
    
    
    func setUpLayout()  {
        self.view.addSubview(messageLabel)
        self.view.addSubview(resendCodeButton)
        
        let codeStack = UIStackView(arrangedSubviews: [firstCodeTextField,secondCodeTextField,thirdCodeTextField,fourthCodeTextField,fithCodeTextField,sixCodeTextField])
        codeStack.translatesAutoresizingMaskIntoConstraints = false
        codeStack.distribution = .fillEqually
        codeStack.axis = .horizontal
        codeStack.spacing = 10
        self.view.addSubview(codeStack)
        
        codeStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        codeStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        codeStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        codeStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        codeStack.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        messageLabel.bottomAnchor.constraint(equalTo: codeStack.topAnchor, constant: -50).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        resendCodeButton.topAnchor.constraint(equalTo: codeStack.bottomAnchor, constant: 50).isActive = true
        resendCodeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        resendCodeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        resendCodeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //MARK - auto advance input fields
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if text?.utf16.count==1{
            switch textField{
            case firstCodeTextField:
                secondCodeTextField.becomeFirstResponder()
            case secondCodeTextField:
                thirdCodeTextField.becomeFirstResponder()
            case thirdCodeTextField:
                fourthCodeTextField.becomeFirstResponder()
            case fourthCodeTextField:
                fithCodeTextField.becomeFirstResponder()
            case fithCodeTextField:
                sixCodeTextField.becomeFirstResponder()
            case sixCodeTextField:
                sixCodeTextField.resignFirstResponder()
                self.startVerification()
            default:
                break
            }
        }else{
            
        }
    }
    
    @objc private func resendCode() {
        self.apiService.resendVerificationCode() { (status, message) in
            self.utilController.hideActivityIndicator()
            let appearance = SCLAlertView.SCLAppearance(dynamicAnimatorActive: true)
            if status != ApiCallStatus.SUCCESS {
                SCLAlertView(appearance: appearance).showError("SpeakUpp Error", subTitle: message)
            }  else {
               SCLAlertView(appearance: appearance).showSuccess("Code Sent", subTitle: message)
            }
        }
    }

}

extension VerificationCodeController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //self.startVerification()
    }
    
    func startVerification()  {
        let code = "\(firstCodeTextField.text!)\(secondCodeTextField.text!)\(thirdCodeTextField.text!)\(fourthCodeTextField.text!)\(fithCodeTextField.text!)\(sixCodeTextField.text!)"
        if (code.count == 6){
            self.utilController.showActivityIndicator()
            self.apiService.verifyRegisterationCode(uniqueCode: code, completion: { (status, message) in
                self.utilController.hideActivityIndicator()
                if status != ApiCallStatus.SUCCESS {
                    let appearance = SCLAlertView.SCLAppearance(dynamicAnimatorActive: true)
                    SCLAlertView(appearance: appearance).showError("SpeakUpp Error", subTitle: message)
                }  else {
                    let vc = InterestController()
                    vc.isOnboard = true
                    self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
                }
            })
        }
    }

}
