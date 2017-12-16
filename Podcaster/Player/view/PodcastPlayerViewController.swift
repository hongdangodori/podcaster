//
//  PodcastPlayerViewController.swift
//  Podcaster
//
//  Created by Coupang on 2017. 12. 15..
//  Copyright © 2017년 Byoungho. All rights reserved.
//

import UIKit

class PodcastPlayerViewController: UIViewController {
    public var minimumVelocityToHide: CGFloat = 150
    public var minimumScreenRatioToHide: CGFloat = 0.05
    public var animationDuration: TimeInterval = 0.2
    public let playerHeight: CGFloat = 50
    private var panHeight: CGFloat = 0
    
    private var isTop: Bool = true
    public var topInsets: CGFloat = 0.0
    public var bottomInsets: CGFloat = 0.0
//    @IBOutlet weak var playerBarView: UIView!
//    @IBOutlet weak var tableView: UITableView!
    
    private var isPanning = false
    
    public var willPopClosure: ((_ isPopUp: Bool) -> Void)?
    public var didPopClosure: ((_ isPopUp: Bool) -> Void)?
    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        panHeight = self.view.frame.size.height
//
//        playerBarView.alpha = 0.0
//        tableView.delegate = self
//        tableView.panGestureRecognizer.delaysTouchesBegan = true
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
//        self.view.addGestureRecognizer(panGesture)
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didPlayerViewTapped(_:)))
//        playerBarView.addGestureRecognizer(tapGesture)
//    }
//
//    func slideViewVerticallyTo(_ y: CGFloat) {
//        self.view.frame.origin = CGPoint(x: 0, y: y)
//    }
//
//    @objc func didPlayerViewTapped(_ tapGesture: UITapGestureRecognizer) {
//        UIView.animate(withDuration: animationDuration, animations: {
//            self.slideViewVerticallyTo(self.topInsets)
//            self.isTop = !self.isTop
//        })
//
//    }
//
//    @objc func onPan(_ panGesture: UIPanGestureRecognizer) {
//        self.willPopClosure?(!self.isTop)
//        switch panGesture.state {
//        case .began, .changed:
//            isPanning = true
//            // If pan started or is ongoing then
//            // slide the view to follow the finger
//            let translation = panGesture.translation(in: view)
//            let y = isTop ? max(topInsets, translation.y) : min(topInsets, translation.y)
//
//            if !isTop && translation.y > 0 {
//                break
//            }
//            self.playerBarView.alpha = (isTop ? y : self.view.frame.size.height + y) / self.view.frame.size.height
//            self.slideViewVerticallyTo(isTop ? y : self.view.frame.size.height - self.playerHeight + y)
//            break
//        case .ended:
//            // If pan ended, decide it we should close or reset the view
//            // based on the final position and the speed of the gesture
//            let translation = panGesture.translation(in: view)
//            let velocity = panGesture.velocity(in: view)
//            let closing = (isTop ? translation.y > self.view.frame.size.height * minimumScreenRatioToHide : translation.y < -self.view.frame.size.height * minimumScreenRatioToHide) ||
//                (velocity.y > minimumVelocityToHide)
//            isPanning = false
//            if closing {
//                UIView.animate(withDuration: animationDuration, animations: {
//                    // If closing, animate to the bottom of the view
//                    self.playerBarView.alpha = self.isTop ? 1.0 : 0.0
//                    self.slideViewVerticallyTo(self.isTop ? self.view.frame.size.height - self.playerHeight : self.topInsets)
//                    self.isTop = !self.isTop
//                    self.didPopClosure?(self.isTop)
//                })
//            } else {
//                // If not closing, reset the view to the top
//                UIView.animate(withDuration: animationDuration, animations: {
//                    self.playerBarView.alpha = self.isTop ? 0.0 : 1.0
//                    self.slideViewVerticallyTo(self.isTop ? self.topInsets : self.view.frame.size.height - self.playerHeight)
//                    self.didPopClosure?(self.isTop)
//                })
//            }
//            break
//        default:
//            // If gesture state is undefined, reset the view to the top
//            isPanning = false
//            UIView.animate(withDuration: animationDuration, animations: {
//                self.playerBarView.alpha = self.isTop ? 0.0 : 1.0
//                self.slideViewVerticallyTo(self.isTop ? self.topInsets : self.view.frame.size.height - self.playerHeight)
//                self.didPopClosure?(self.isTop)
//            })
//            break
//        }
//
//
//    }
//
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen;
        self.modalTransitionStyle = .coverVertical;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.modalPresentationStyle = .overFullScreen;
        self.modalTransitionStyle = .coverVertical;
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
}


extension PodcastPlayerViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        
        if scrollOffset < 0 || isPanning {
            scrollView.contentOffset.y = 0
//            onPan(scrollView.panGestureRecognizer)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        onPan(scrollView.panGestureRecognizer)
    }
}


extension PodcastPlayerViewController: WindowTouchesDelegate {
    func window(_ window: UIWindow?, shouldReceiveTouchAtPoint point: CGPoint) -> Bool {
        return view.bounds.contains(view.convert(point, from: window))
    }
}
