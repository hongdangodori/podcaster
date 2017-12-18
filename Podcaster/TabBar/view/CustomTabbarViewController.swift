//
//  CustomTabbarViewController.swift
//  Podcaster
//
//  Created by Coupang on 2017. 12. 18..
//  Copyright © 2017년 Byoungho. All rights reserved.
//

import UIKit

class CustomTabbarViewController: UITabBarController {

    var podcastPlayerView = PopupSlideTableView(miniPlayerHeight: 50)
    var playInfoView = PopupSlideTableView(miniPlayerHeight: 30)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(podcastPlayerView)
        view.bringSubview(toFront: tabBar)
        podcastPlayerView.bottomInsets = 50
        podcastPlayerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        let tabBarCenterY = tabBar.center.y

        podcastPlayerView.progressPopClosure = {
            self.tabBar.center = CGPoint(x: self.tabBar.center.x, y: tabBarCenterY + self.tabBar.bounds.height * (100 - $0) / 100)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
