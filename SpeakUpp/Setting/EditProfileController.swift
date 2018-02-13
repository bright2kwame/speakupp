//
//  EditProfileController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 13/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import Dodo
import DLRadioButton
import ActionSheetPicker_3_0
import DKImagePickerController

class EditProfileController: UIViewController {
    
    let pickerController = DKImagePickerController()
    let apiService = ApiService()
    var parsableDate = ""
    let utilController = ViewControllerHelper()
    let labelWidth = CGFloat(60)
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
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
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "UserIcon")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    
    override func viewDidLoad() {
        self.setUpLayouts()
        
        self.setUpNavigationBar()
    }
    
    
    private func setUpNavigationBar()  {
        navigationItem.title = "Edit Profile"
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        
        let image = UIImage(named: "BackArrow")?.withRenderingMode(.alwaysOriginal)
        let menuBack = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = menuBack
        
        let menuSave = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(updateUser))
        navigationItem.rightBarButtonItem = menuSave
    }
    
    @objc func handleCancel()  {
        dismiss(animated: true, completion: nil)
    }
    
    
    func setUpLayouts()  {

        self.view.addSubview(imageView)
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(profileImageView)
        self.scrollView.addSubview(nameLabel)
        self.scrollView.addSubview(nameUnderlineView)
        self.scrollView.addSubview(nameTextField)
        self.scrollView.addSubview(phoneNumberLabel)
        self.scrollView.addSubview(numberTextField)
        self.scrollView.addSubview(numberDividerView)
        self.scrollView.addSubview(genderLabel)
        self.scrollView.addSubview(genderUnderlineView)
        self.scrollView.addSubview(maleButton)
        self.scrollView.addSubview(feMaleButton)
        self.scrollView.addSubview(dateOfBirthLabel)
        self.scrollView.addSubview(datePickerButton)
  
        self.imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        
        let screenWidth = self.view.frame.width
        self.scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 0).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 0).isActive = true
        self.scrollView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        
        self.profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.profileImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        //MARK -- name section
        self.nameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.nameLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        self.nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40).isActive = true
        
        self.nameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40).isActive = true
        self.nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 4).isActive = true
        self.nameTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.nameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.nameUnderlineView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        self.nameUnderlineView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        //self.nameUnderlineView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.nameUnderlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.nameUnderlineView.widthAnchor.constraint(equalToConstant: screenWidth-32).isActive = true
        
        
        //MARK - phone number section
        self.phoneNumberLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.phoneNumberLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        self.phoneNumberLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.phoneNumberLabel.topAnchor.constraint(equalTo: nameUnderlineView.bottomAnchor, constant: 16).isActive = true
    
        self.numberTextField.topAnchor.constraint(equalTo: nameUnderlineView.bottomAnchor, constant: 16).isActive = true
        self.numberTextField.leadingAnchor.constraint(equalTo: phoneNumberLabel.trailingAnchor, constant: 4).isActive = true
        self.numberTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.numberTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.numberDividerView.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 4).isActive = true
        self.numberDividerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        //self.numberDividerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.numberDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.numberDividerView.widthAnchor.constraint(equalToConstant: screenWidth-32).isActive = true
        
        //MARK - gender section
        self.genderLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.genderLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        self.genderLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.genderLabel.topAnchor.constraint(equalTo: numberDividerView.bottomAnchor, constant: 16).isActive = true
        
        self.maleButton.topAnchor.constraint(equalTo: numberDividerView.bottomAnchor, constant: 25).isActive = true
        self.maleButton.leadingAnchor.constraint(equalTo: genderLabel.trailingAnchor, constant: 4).isActive = true
        self.maleButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.maleButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.feMaleButton.topAnchor.constraint(equalTo: numberDividerView.bottomAnchor, constant: 25).isActive = true
        self.feMaleButton.leadingAnchor.constraint(equalTo: maleButton.trailingAnchor, constant: 4).isActive = true
        self.feMaleButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.feMaleButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.genderUnderlineView.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 4).isActive = true
        self.genderUnderlineView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        //self.genderUnderlineView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.genderUnderlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.genderUnderlineView.widthAnchor.constraint(equalToConstant: screenWidth-32).isActive = true
        
        //MARK - date of birth section
        self.dateOfBirthLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.dateOfBirthLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        self.dateOfBirthLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.dateOfBirthLabel.topAnchor.constraint(equalTo: genderUnderlineView.bottomAnchor, constant: 16).isActive = true
        
        self.datePickerButton.topAnchor.constraint(equalTo: genderUnderlineView.bottomAnchor, constant: 16).isActive = true
        self.datePickerButton.leadingAnchor.constraint(equalTo: dateOfBirthLabel.trailingAnchor, constant: 4).isActive = true
        self.datePickerButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.datePickerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //self.datePickerButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        
        //tapped image
        let tappedImage = UITapGestureRecognizer(target: self, action: #selector(showAction(gesture:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tappedImage)
        
        self.setUpUIElements()
    }
    
    func setUpUIElements()  {
        if let user = User.getUser() {
            self.profileImageView.af_setImage(
                withURL: URL(string: (user.profile))!,
                placeholderImage: Mics.userPlaceHolder(),
                imageTransition: .crossDissolve(0.2)
            )
            
            self.nameTextField.text = user.fullName
            if user.gender == "M" {
                self.maleButton.isSelected = true
                self.feMaleButton.isSelected = false
            }else {
                self.maleButton.isSelected = false
                self.feMaleButton.isSelected = true
            }
            self.datePickerButton.setTitle(user.birthday.formateAsShortDate(), for: .normal)
            self.numberTextField.text = user.number
            self.numberTextField.isEnabled = false
        }
    }
    
    @objc private func updateUser() {
        let number =  numberTextField.text!
        let name = nameTextField.text!
        
        
     
    }
    
    
    func getImage(asset:DKAsset) -> Void {
        asset.fetchFullScreenImage(true, completeBlock: { resultImage, info in
            self.profileImageView.image = nil
            self.profileImageView.image = resultImage
            self.apiService.startUpload(file: resultImage!, nameOfFolder: "PROFILE", completion: { (status,fileUrl,message) in
                 print(message)
            })
        })
    }
    
    //MARK- start image picking
    @objc func showAction(gesture: UITapGestureRecognizer) {
        pickerController.maxSelectableCount = 1
        pickerController.assetType = .allPhotos
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            self.getImage(asset: assets[0])
        }
        
        let alertActionControl = UIAlertController.init(title: nil, message: "Pick from", preferredStyle: .actionSheet)
        let alertActionGallery = UIAlertAction.init(title: "Gallery", style: .default) {(Alert:UIAlertAction!) -> Void in
            self.present(self.pickerController, animated: true) {}
        }
        let alertActionCancel = UIAlertAction.init(title: "Cancel", style: .cancel) {(Alert:UIAlertAction!) -> Void in
        }
        alertActionControl.addAction(alertActionGallery)
        alertActionControl.addAction(alertActionCancel)
        self.present(alertActionControl,animated:true,completion:nil)
    }
    
    @objc private func closeAction(gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
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
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            self.parsableDate = dateFormatterGet.string(from: value! as! Date)
            
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

extension EditProfileController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        return true
    }
    
}


