//
//  WelcomeController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 22/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class WelcomeController: UIViewController {
    
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
    
    let getStartedButton: UIButton = {
        let button = ViewControllerHelper.baseButton()
        let color = UIColor.hex(hex: Key.startedButtonColor)
        button.setTitle("Let's Get Started", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = color
        button.layer.cornerRadius = 25
        button.layer.borderColor = color.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(actionGetStarted), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.hex(hex: Key.primaryHexCode)
        self.setUpLayouts()
    }
    

    
    func setUpLayouts()  {
        
        self.view.addSubview(imageView)
        self.view.addSubview(profileImageView)
        self.view.addSubview(getStartedButton)
      
        
        self.imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        self.profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        self.profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        self.profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        self.getStartedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        self.getStartedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        self.getStartedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        self.getStartedButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    
    @objc private func actionGetStarted() {
        let vc = OnboardViewController()
        self.present(vc, animated: true, completion: nil)
    }
}

