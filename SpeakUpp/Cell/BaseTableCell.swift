//
//  BaseTableCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 15/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit


class BaseTableCell: UITableViewCell {
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        backgroundColor = UIColor.clear
        self.setUpView()
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView(){
        
    }
}

