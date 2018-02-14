//
//  LogoOutController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 30/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class LogoOutController: UIViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppBg")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let logOutButton: UIButton = {
        let button = ViewControllerHelper.baseButton()
        let color = UIColor.red
        button.setTitle("Log Out", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 0
        button.layer.borderWidth = 1
        button.layer.borderColor = color.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = ViewControllerHelper.baseButton()
        let color = UIColor.clear
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 0
        button.layer.borderWidth = 0
        button.layer.borderColor = color.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()
    
    let titleLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30)]
        
        let header = NSMutableAttributedString(string: "Are you sure you want to log out?\n", attributes: attributes)
      
        let combinedText = NSMutableAttributedString()
        combinedText.append(header)
    
        textView.textAlignment = .center
        textView.attributedText = combinedText
        textView.textColor = UIColor.white
        return textView
    }()
    
    override func viewDidLoad() {
        self.setUpView()
    }
    
    func setUpView() {
        
        self.view.addSubview(imageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(logOutButton)
        self.view.addSubview(cancelButton)
        
        
        self.imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        self.titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        self.titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.logOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        self.logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        self.logOutButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        self.logOutButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        self.cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        self.cancelButton.topAnchor.constraint(equalTo: logOutButton.bottomAnchor, constant: 16).isActive = true
        self.cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
     
        
    }
    
    @objc private func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func logoutAction() {
        User.delete()
        
        let vc = LoginController()
        self.present(vc, animated: true, completion: nil)
        
    }
}
