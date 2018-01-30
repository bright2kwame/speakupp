//
//  SettingController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 30/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class SettingController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.alwaysBounceVertical = true
        scrollView.sizeToFit()
        scrollView.contentSize = contentView.bounds.size
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.clear
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    
    override func viewDidLoad() {
        self.setUpView()
    }
    
    func setUpView() {
        self.setUpNavigationBar()
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        
        let screenWidth = self.view.frame.width
        self.scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 0).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 0).isActive = true
        self.scrollView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        
        self.contentView.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 0).isActive = true
        self.contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        self.contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor,constant: 0).isActive = true
        self.contentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        
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
}
