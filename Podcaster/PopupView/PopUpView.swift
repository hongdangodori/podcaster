//
//  PopUpView.swift
//  Podcaster
//
//  Created by Coupang on 2017. 12. 16..
//  Copyright © 2017년 Byoungho. All rights reserved.
//

import UIKit

class PopUpView: UIView {
    public var minimumVelocityToHide: CGFloat = 150
    public var minimumScreenRatioToHide: CGFloat = 0.05
    public var animationDuration: TimeInterval = 0.2
    public let playerHeight: CGFloat = 50

    private var isTop: Bool = true
    public var topInsets: CGFloat = 0.0
    public var bottomInsets: CGFloat = 0.0
    
    public var containerView: UIView?
    
    private var isPopping = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commitInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commitInit()
    }
    
    func commitInit() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    func slideViewVerticallyTo(_ y: CGFloat) {
        frame.origin = CGPoint(x: 0, y: y)
    }
    
    @objc func didPlayerViewTapped(_ tapGesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.slideViewVerticallyTo(self.topInsets)
            self.isTop = !self.isTop
        })
    }
    
    @objc func onPan(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began, .changed:
            isPopping = true
            // If pan started or is ongoing then
            // slide the view to follow the finger
            let translation = panGesture.translation(in: self)
            let y = isTop ? max(topInsets, translation.y) : min(topInsets, translation.y)
            
            if !isTop && translation.y > 0 {
                break
            }
            self.slideViewVerticallyTo(isTop ? y : frame.size.height - playerHeight + y)
            break
        case .ended:
            // If pan ended, decide it we should close or reset the view
            // based on the final position and the speed of the gesture
            let translation = panGesture.translation(in: self)
            let velocity = panGesture.velocity(in: self)
            let closing = (isTop ? translation.y > frame.size.height * minimumScreenRatioToHide : translation.y < -frame.size.height * minimumScreenRatioToHide) ||
                (velocity.y > minimumVelocityToHide)
            isPopping = false
            if closing {
                UIView.animate(withDuration: animationDuration, animations: {
                    // If closing, animate to the bottom of the view
                    
                    self.slideViewVerticallyTo(self.isTop ? self.frame.size.height - self.playerHeight : self.topInsets)
                    self.isTop = !self.isTop
                    
                })
            } else {
                // If not closing, reset the view to the top
                UIView.animate(withDuration: animationDuration, animations: {
                    self.slideViewVerticallyTo(self.isTop ? self.topInsets : self.frame.size.height - self.playerHeight)
                })
            }
            break
        default:
            // If gesture state is undefined, reset the view to the top
            isPopping = false
            UIView.animate(withDuration: animationDuration, animations: {
                self.slideViewVerticallyTo(self.isTop ? self.topInsets : self.frame.size.height - self.playerHeight)
            })
            break
        }
        
        
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        guard view != self else { return nil }
        return view
    }
}

