//
//  MenuButtonCell.swift
//  ezlang
//
//  Created by mac on 06.01.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import UIKit

typealias MainMenuButtonAction = () -> Void

class ButtonCell: UITableViewCell {
    
    @IBOutlet weak private var button: UIButton!

    var buttonClickAction: MainMenuButtonAction?
    
    var buttonTitle: String? {
        get { return button.titleLabel?.text }
        set { button.setTitle(newValue,forState: .Normal) }
    }
    
    @IBAction private func buttonClick(sender: UIButton) {
        buttonClickAction?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.setBackgroundImage(UIImage(named: "menu_button"), forState: .Normal)
        button.setBackgroundImage(UIImage(named: "menu_button_clicked"), forState: .Highlighted)
        
    }
}