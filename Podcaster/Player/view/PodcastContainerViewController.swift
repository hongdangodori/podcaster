//
//  PodcastContainerViewController.swift
//  Podcaster
//
//  Created by Coupang on 2017. 12. 16..
//  Copyright © 2017년 Byoungho. All rights reserved.
//

import UIKit

class PodcastContainerViewController: UIViewController {
    var podcastPlayerView = PodcastPlayerView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(podcastPlayerView)
        
        podcastPlayerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: podcastPlayerView, attribute: .leading, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: podcastPlayerView, attribute: .trailing, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: podcastPlayerView, attribute: .top, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: podcastPlayerView, attribute: .bottom, multiplier: 1.0, constant: 50))
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PodcastContainerViewController: WindowTouchesDelegate {
    func window(_ window: UIWindow?, shouldReceiveTouchAtPoint point: CGPoint) -> Bool {
        var boo = false
        view.subviews.forEach { (view) in
            boo = boo || view.hitTest(point, with: nil) != nil
        }
        
        return boo
    }
}

