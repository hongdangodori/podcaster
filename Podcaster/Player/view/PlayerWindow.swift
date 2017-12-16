//
//  PlayerWindow.swift
//  Podcaster
//
//  Created by Coupang on 2017. 12. 15..
//  Copyright © 2017년 Byoungho. All rights reserved.
//

import UIKit

protocol WindowTouchesDelegate: class {
    func window(_ window: UIWindow?, shouldReceiveTouchAtPoint point: CGPoint) -> Bool
}

class PlayerWindow: UIWindow {
    weak var touchesDelegate: WindowTouchesDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        windowLevel = UIWindowLevelStatusBar + 100
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if let touchesDelegate = touchesDelegate, touchesDelegate.window(self, shouldReceiveTouchAtPoint: point) {
            return super.point(inside: point, with: event)
        }
        
        return false
    }
}
