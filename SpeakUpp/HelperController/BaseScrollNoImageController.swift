//
//  BaseScrollViewController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 25/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class BaseScrollNoImageController: UIViewController {
    
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
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
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
        
        
        self.setUpView()
    }
    
    func setUpView()  {
        
    }
    
}

