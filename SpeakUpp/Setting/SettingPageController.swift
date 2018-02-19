//
//  SettingPageController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 16/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class SettingPageController: UIViewController {
    var header: String?
    let apiService = ApiService()
    var type: SettingType?
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.alwaysBounceVertical = true
        scrollView.sizeToFit()
        scrollView.contentSize = self.view.bounds.size
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentLabel: UILabel = {
        let label = ViewControllerHelper.baseLabel()
        label.textColor = UIColor.darkText
        return label
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        self.setUpNavigationBar()
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentLabel)
        
        let screenWidth = self.view.frame.width
        self.scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 0).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 0).isActive = true
        self.scrollView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
       
        self.contentLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.contentLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.contentLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        self.contentLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16).isActive = true
        self.contentLabel.widthAnchor.constraint(equalToConstant: screenWidth - 32).isActive = true
        
        
        self.setUpUniversalIndication()
        
        if let type = self.type {
           var url = ""
            if (type == SettingType.privacy){
               url = "privacy"
            } else if (type == SettingType.about){
                url = "about"
            }
            self.getData(url: url)
        }
    }
    
    private func setUpNavigationBar()  {
        navigationItem.title = "Settings"
        if let header = self.header {
            navigationItem.title = header
        }
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let image = UIImage(named: "BackArrow")?.withRenderingMode(.alwaysOriginal)
        let menuBack = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = menuBack
    }
    
    func setUpUniversalIndication()   {
        self.indicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        self.indicator.center = view.center
        self.view.addSubview(indicator)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func startProgress() {
        self.indicator.startAnimating()
    }
    
    func stopProgress() {
        self.indicator.stopAnimating()
    }
    
    @objc func handleCancel()  {
        dismiss(animated: true, completion: nil)
    }
    
    func getData(url: String)  {
        self.startProgress()
        self.apiService.getMessages(url: url) { (message, status, report) in
            self.stopProgress()
            if status == ApiCallStatus.SUCCESS {
                if let content = message {
                   self.contentLabel.text = content.htmlToString
                }
            }
        }
    }
    
    
}
