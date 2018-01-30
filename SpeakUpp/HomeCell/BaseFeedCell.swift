//
//  BaseFeedCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 29/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class BaseFeedCell: BaseCell {
    
    var feed: Feed? {
        didSet {
            guard let unwrapedItem = feed else {return}
            
        }
    }
    
    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.hex(hex: Key.primaryHomeHexCode)
        
        
    }
}
