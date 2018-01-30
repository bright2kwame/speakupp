//
//  SearchController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 30/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class SearchController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.setUpViews()
    }
    
    func setUpViews() {
        self.setUpNavigationBar()
        
    }
    private func setUpNavigationBar()  {
        navigationItem.title = "Search SpeakUpp"
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
