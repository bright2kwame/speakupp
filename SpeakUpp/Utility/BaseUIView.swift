//
//  BaseUIView.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 29/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class BaseUIView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpLayout()
    }
    
    func setUpLayout()  {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
