//
//  CheckBox.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 25/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//



import UIKit

class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "CheckBoxSelect")! as UIImage
    let uncheckedImage = UIImage(named: "CheckBox")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControlState.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControlState.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}


