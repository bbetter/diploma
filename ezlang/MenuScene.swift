//
//  MenuScene.swift
//  ezlang
//
//  Created by mac on 10.01.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import SpriteKit
import Foundation
import UIKit

class MenuScene: SKScene{

    var buttons : [SKButton] = []
    var buttonsLayer: SKNode?
    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)

        let background = SKSpriteNode(imageNamed: "menu_bg")
        let logo = SKSpriteNode(imageNamed: "logo")
        buttonsLayer = SKNode()
        logo.anchorPoint = CGPoint(x: 0.5, y: -1.2)
        logo.size = CGSize(width: 200,height:150)

        addChild(background)
        addChild(logo)

        buttons.append(SKMenuButton(text:NSLocalizedString("new_game",comment:"")))
        buttons.append(SKMenuButton(text:NSLocalizedString("profile",comment:"")))
        buttons.append(SKMenuButton(text:NSLocalizedString("settings",comment:"")))
        buttons.append(SKMenuButton(text:NSLocalizedString("help",comment:"")))
        buttons.append(SKMenuButton(text:NSLocalizedString("feedback",comment:"")))

        for var i = buttons.count - 1; i >= 0; --i {
            buttons[i].position = CGPoint(x:10,y: 100 - (i * 50));
            buttonsLayer!.addChild(buttons[i])
        }
        addChild(buttonsLayer!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let location = touch.locationInNode(buttonsLayer!)
        let locationInScene = touch.locationInNode(self)
    }
}
