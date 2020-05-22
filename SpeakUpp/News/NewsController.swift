//
//  NewsController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 20/05/2020.
//  Copyright © 2020 Bright Limited. All rights reserved.
//

import UIKit

class NewsController: UIViewController {
    var newsItem: NewsItem?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.backgroundColor = UIColor.white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        return textView
    }()
       
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(scrollView)
            
        self.scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
       
        self.scrollView.addSubview(contentLabel)
        
        self.contentLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.contentLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.contentLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        self.contentLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        self.contentLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        
        self.setUpNavigationBar()
        
        guard let unwrapedItem = self.newsItem else {return}
        let header = "\(unwrapedItem.title)\n\n".attributeText(fontSize: 16)
                 let content = "\(unwrapedItem.content)".attributeText(fontSize: 14)
                 let resultingAmount = NSMutableAttributedString()
                 resultingAmount.append(header)
                 resultingAmount.append(content)
                 
        self.contentLabel.attributedText = resultingAmount
        
        
    }

    private func setUpNavigationBar()  {
         let heading = "News Detail"
         navigationItem.title = heading
         navigationController?.navigationBar.isTranslucent = false
            
         navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
         navigationController?.navigationBar.shadowImage = UIImage()
    }
}
