//
//  PodcastPlayerView.swift
//  Podcaster
//
//  Created by Coupang on 2017. 12. 16..
//  Copyright © 2017년 Byoungho. All rights reserved.
//

import UIKit

class PodcastPlayerView: UIView {
    public var minimumVelocityToHide: CGFloat = 150
    public var minimumScreenRatioToHide: CGFloat = 0.05
    public var animationDuration: TimeInterval = 0.2
    public let playerHeight: CGFloat = 50
    
    
    @IBOutlet var podcastPlayerView: UIView!
    private var isTop: Bool = true
    public var topInsets: CGFloat = -50.0
    public var bottomInsets: CGFloat = 0.0
    
    @IBOutlet weak var playerBarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var popupHeightConstraint: NSLayoutConstraint!
    
    private var isPanning = false
    
    public var willPopClosure: ((_ isPopUp: Bool) -> Void)?
    public var didPopClosure: ((_ isPopUp: Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commitInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commitInit()
    }
    
    func commitInit() {
        clipsToBounds = true
        Bundle.main.loadNibNamed("PodcastPlayerView", owner: self, options: nil)
        podcastPlayerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(podcastPlayerView)
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: podcastPlayerView, attribute: .leading, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: podcastPlayerView, attribute: .trailing, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: podcastPlayerView, attribute: .top, multiplier: 1.0, constant: 50))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: podcastPlayerView, attribute: .bottom, multiplier: 1.0, constant: 0))
        playerBarView.alpha = 0.0
        tableView.delegate = self
        tableView.panGestureRecognizer.delaysTouchesBegan = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        self.addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didPlayerViewTapped(_:)))
        playerBarView.addGestureRecognizer(tapGesture)
    }
    
    func slideViewVerticallyTo(_ y: CGFloat) {
        podcastPlayerView.frame.origin = CGPoint(x: 0, y: y)
    }
    
    @objc func didPlayerViewTapped(_ tapGesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.slideViewVerticallyTo(self.topInsets)
            self.isTop = !self.isTop
        })
        
    }
    
    @objc func onPan(_ panGesture: UIPanGestureRecognizer) {
        self.willPopClosure?(!self.isTop)
        switch panGesture.state {
        case .began, .changed:
            isPanning = true
            // If pan started or is ongoing then
            // slide the view to follow the finger
            let translation = panGesture.translation(in: self)
            let y = isTop ? max(topInsets, translation.y) : min(topInsets, translation.y)
            
            if !isTop && translation.y > 0 {
                break
            }
            self.playerBarView.alpha = (isTop ? y : frame.size.height + y) / frame.size.height
            self.slideViewVerticallyTo(isTop ? y : frame.size.height - playerHeight + y)
            break
        case .ended:
            // If pan ended, decide it we should close or reset the view
            // based on the final position and the speed of the gesture
            let translation = panGesture.translation(in: self)
            let velocity = panGesture.velocity(in: self)
            let closing = (isTop ? translation.y > frame.size.height * minimumScreenRatioToHide : translation.y < -frame.size.height * minimumScreenRatioToHide) ||
                (velocity.y > minimumVelocityToHide)
            isPanning = false
            if closing {
                UIView.animate(withDuration: animationDuration, animations: {
                    // If closing, animate to the bottom of the view
                    self.playerBarView.alpha = self.isTop ? 1.0 : 0.0
                    self.slideViewVerticallyTo(self.isTop ? self.frame.size.height - self.playerHeight : self.topInsets)
                    self.isTop = !self.isTop
                    self.didPopClosure?(self.isTop)
                })
            } else {
                // If not closing, reset the view to the top
                UIView.animate(withDuration: animationDuration, animations: {
                    self.playerBarView.alpha = self.isTop ? 0.0 : 1.0
                    self.slideViewVerticallyTo(self.isTop ? self.topInsets : self.frame.size.height - self.playerHeight)
                    self.didPopClosure?(self.isTop)
                })
            }
            break
        default:
            // If gesture state is undefined, reset the view to the top
            isPanning = false
            UIView.animate(withDuration: animationDuration, animations: {
                self.playerBarView.alpha = self.isTop ? 0.0 : 1.0
                self.slideViewVerticallyTo(self.isTop ? self.topInsets : self.frame.size.height - self.playerHeight)
                self.didPopClosure?(self.isTop)
            })
            break
        }
        
        
    }

    @IBAction func didMediaButtonTouched(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        if button.image(for: .normal) == #imageLiteral(resourceName: "playIcon") {
            button.setImage(#imageLiteral(resourceName: "pauseIcon"), for: .normal)
            button.setImage(#imageLiteral(resourceName: "pauseIconDark"), for: .highlighted)
        } else {
            button.setImage(#imageLiteral(resourceName: "playIcon"), for: .normal)
            button.setImage(#imageLiteral(resourceName: "playIconDark"), for: .highlighted)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        guard view != self else { return nil }
        return view
    }
}


extension PodcastPlayerView: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        
        if scrollOffset < 0 || isPanning {
            scrollView.contentOffset.y = 0
            onPan(scrollView.panGestureRecognizer)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        onPan(scrollView.panGestureRecognizer)
    }
}


//extension PodcastPlayerView: WindowTouchesDelegate {
//    func window(_ window: UIWindow?, shouldReceiveTouchAtPoint point: CGPoint) -> Bool {
//        return view.bounds.contains(view.convert(point, from: window))
//    }
//}

