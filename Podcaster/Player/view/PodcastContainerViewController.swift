//
//  PodcastContainerViewController.swift
//  Podcaster
//
//  Created by Coupang on 2017. 12. 16..
//  Copyright © 2017년 Byoungho. All rights reserved.
//

import UIKit

class PodcastContainerViewController: UIViewController {
    var podcastPlayerView = PopupSlideTableView(miniPlayerHeight: 50)
    var playInfoView = PopupSlideTableView(miniPlayerHeight: 30)
    var didPopClosure: ((_ didPopped: Bool) -> ())?
    var bottomConstraint: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        playInfoView.topPadding = 300
        view.addSubview(podcastPlayerView)
        view.addSubview(playInfoView)
        var bottomPadding: CGFloat = 0
        if #available(iOS 11.0, *) {
            bottomPadding = view.safeAreaInsets.bottom
        }
        podcastPlayerView.translatesAutoresizingMaskIntoConstraints = false
        podcastPlayerView.miniSummaryBarHeight = 100
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: podcastPlayerView, attribute: .leading, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: podcastPlayerView, attribute: .trailing, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: podcastPlayerView, attribute: .top, multiplier: 1.0, constant: 0))
        bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: podcastPlayerView, attribute: .bottom, multiplier: 1.0, constant: 50)
        view.addConstraint(bottomConstraint!)
        playInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: playInfoView, attribute: .leading, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: playInfoView, attribute: .trailing, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: playInfoView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: playInfoView, attribute: .bottom, multiplier: 1.0, constant: 0))
        // Do any additional setup after loading the view.
        podcastPlayerView.didPopClosure = { [weak self] in
            self?.didPopClosure?($0)
        }
        
        playInfoView.didPopClosure = {
            self.didPopClosure?($0)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PodcastContainerViewController: WindowTouchesDelegate {
    func window(_ window: UIWindow?, shouldReceiveTouchAtPoint point: CGPoint) -> Bool {
        var boo = false
        view.subviews.forEach { (superView) in
            superView.subviews.forEach { (view) in
                boo = boo || (view.bounds.contains(view.convert(point, from: window)) && superView.bounds.contains(superView.convert(point, from: window)) && !view.isHidden)
            }
        }
        
        return boo
    }
}

