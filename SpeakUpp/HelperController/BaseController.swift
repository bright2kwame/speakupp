//
//  BaseController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 25/06/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class BaseController: UIViewController {
    
    
    func setUpNavigationBar(title:String)  {
        navigationItem.title = "\(title)"
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let image = UIImage(named: "BackArrow")?.withRenderingMode(.alwaysOriginal)
        let menuBack = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = menuBack
    }
    
    @objc func handleCancel()  {
        self.dismiss(animated: true, completion: nil)
    }
}
