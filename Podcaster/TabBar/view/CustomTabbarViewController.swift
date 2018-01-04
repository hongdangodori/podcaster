//
//  CustomTabbarViewController.swift
//  Podcaster
//
//  Created by Coupang on 2017. 12. 18..
//  Copyright © 2017년 Byoungho. All rights reserved.
//

import UIKit

let popupPlayInfoView = "popup.play.info.view"

class CustomTabbarViewController: UITabBarController {

    var podcastPlayerView = PopupSlideTableView(miniPlayerHeight: 50)
    var playInfoView = PopupSlideTableView(miniPlayerHeight: 0)
    var nowPlayingView = NowPlayingView(frame: .zero)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(popupPlayerInfoView(_:)), name: NSNotification.Name(popupPlayInfoView), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(popupPlayerInfoView(_:)), name: NSNotification.Name(popupPlayInfoView), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(podcastPlayerView)
        view.bringSubview(toFront: tabBar)
        podcastPlayerView.bottomInsets = 50
        podcastPlayerView.center = view.center
        podcastPlayerView.bounds = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        let tabBarCenterY = tabBar.center.y
        podcastPlayerView.summaryBarView = nowPlayingView
        nowPlayingView.didCloseButtonTouched = { [weak self] in
            self?.podcastPlayerView.isHidden = true
        }
        podcastPlayerView.progressPopClosure = {
            self.tabBar.center = CGPoint(x: self.tabBar.center.x, y: tabBarCenterY + self.tabBar.bounds.height * (100 - $0) / 100)
        }
        
        view.addSubview(playInfoView)
        playInfoView.topPadding = view.bounds.height * 0.2
        playInfoView.center = view.center
        playInfoView.bounds = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func popupPlayerInfoView(_ sender: Any) {
        playInfoView.popUpPlayerView(animated: true)
        podcastPlayerView.isHidden =  false
//        guard let notification = sender as? Notification else { return }
    }
}
