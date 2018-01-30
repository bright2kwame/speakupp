//
//  HomeMenuBarCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 29/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class HomeMenuBarCell: BaseCell {
    
    var menuItem: HomeMenuLabel? {
        didSet {
            guard let unwrapedMenuItem = menuItem else {return}
            label.text = unwrapedMenuItem.title
            imageView.image = UIImage(named: unwrapedMenuItem.image)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.label.textColor = isHighlighted ? UIColor.hex(hex: Key.primaryHexCode) : UIColor.lightGray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.label.textColor = isSelected ? UIColor.hex(hex: Key.primaryHexCode) : UIColor.lightGray
        }
    }
    
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.white
        addSubview(imageView)
        addSubview(label)
       
        
        label.heightAnchor.constraint(equalToConstant: 15).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 8).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        imageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -4).isActive = true
    
    }
}
