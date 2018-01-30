//
//  ProfileCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 30/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class ProfileCell: BaseCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppBg")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func setUpView() {
        super.setUpView()
        
        addSubview(imageView)
     
        self.imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        self.imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
    }
}
