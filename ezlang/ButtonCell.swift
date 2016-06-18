//
//  MenuButtonCell.swift
//  ezlang
//
//  Created by mac on 06.01.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import UIKit

typealias SimpleButtonAction = () -> Void

class ButtonCell: UITableViewCell {
    
    @IBOutlet weak private var cellButton: UIButton?
    @IBOutlet weak private var cellImage: UIImageView?

    var buttonClickAction: SimpleButtonAction?
    
    var cellButtonTitle: String? {
        get { return cellButton?.titleLabel?.text }
        set { cellButton?.setTitle(newValue,forState: .Normal) }
    }

    var cellImageValue: UIImage? {
        get { return cellImage?.image }
        set { cellImage?.image = newValue}
    }
    
    @IBAction private func buttonClick(sender: UIButton) {
        buttonClickAction?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellButton?.setBackgroundImage(UIImage(named: "menu_button"), forState: .Normal)
        cellButton?.setBackgroundImage(UIImage(named: "menu_button_clicked"), forState: .Highlighted)
    }
}