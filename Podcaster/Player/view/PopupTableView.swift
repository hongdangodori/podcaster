//
//  PodcastPlayerView.swift
//  Podcaster
//
//  Created by Coupang on 2017. 12. 16..
//  Copyright © 2017년 Byoungho. All rights reserved.
//

import UIKit

class PopupTableView: UIView {
    public let minimumVelocityToHide: CGFloat = 1500
    public let minimumScreenRatioToHide: CGFloat = 0.1
    public let animationDuration: TimeInterval = 0.2
    
    @IBOutlet weak var deemedView: UIView!
    
    public var miniSummaryBarHeight: CGFloat {
        didSet {
            miniSummaryBarHeightConstraint.constant = miniSummaryBarHeight
            layoutIfNeeded()
        }
    }
    
    @IBOutlet weak var miniSummaryBarHeightConstraint: NSLayoutConstraint!
    
    private var topInsets: CGFloat {
        return -miniSummaryBarHeight
    }
    
    public var topPadding: CGFloat = 0 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    private var bottomInsets: CGFloat = 0.0
    
    private var isPoppedUp: Bool = true
    private var isPanning = false
    private var withDeemedView = false
    
    private var topPaddingConstraint: NSLayoutConstraint?
    public var willPopClosure: ((_ isPopUp: Bool) -> Void)?
    public var didPopClosure: ((_ isPopUp: Bool) -> Void)?
    
    override init(frame: CGRect) {
        miniSummaryBarHeight = 0
        miniSummaryBarHeightConstraint.constant = 0
        super.init(frame: frame)
        commitInit()
    }
    
    @IBOutlet private var popupView: UIView!
    @IBOutlet private weak var miniSummaryBarView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    
    init(miniPlayerHeight: CGFloat) {
        miniSummaryBarHeight = miniPlayerHeight
        super.init(frame: .zero)
        commitInit()
        miniSummaryBarHeightConstraint.constant = miniPlayerHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        miniSummaryBarHeight = 0
        miniSummaryBarHeightConstraint.constant = 0
        super.init(coder: aDecoder)
        commitInit()
    }
    
    func commitInit() {
        Bundle.main.loadNibNamed("PopupTableView", owner: self, options: nil)
        clipsToBounds = true
        layoutDeemedView()
        layoutPodcastPlayerView()
        setupRecognizers()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.panGestureRecognizer.delaysTouchesBegan = true
        
        miniSummaryBarView.alpha = 1.0
        deemedView.alpha = 0.0
        deemedView.isHidden = true
        
        isPoppedUp = false
    }
    
    func setupRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        popupView.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSummaryViewTapped(_:)))
        miniSummaryBarView.addGestureRecognizer(tapGesture)
        
        let deemedViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(didDeemedViewTapped(_:)))
        deemedView.addGestureRecognizer(deemedViewTapGesture)
    }
    
    func layoutDeemedView() {
        deemedView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(deemedView)
        addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: deemedView, attribute: .leading, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: deemedView, attribute: .trailing, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: deemedView, attribute: .top, multiplier: 1.0, constant: miniSummaryBarHeight))
        addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: deemedView, attribute: .bottom, multiplier: 1.0, constant: 0))
    }
    
    func layoutPodcastPlayerView() {
        popupView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(popupView)
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: popupView, attribute: .leading, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: popupView, attribute: .trailing, multiplier: 1.0, constant: 0))
        topPaddingConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: popupView, attribute: .top, multiplier: 1.0, constant: miniSummaryBarHeight)
        addConstraint(topPaddingConstraint!)
        addConstraint(NSLayoutConstraint(item: popupView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: miniSummaryBarHeight))
    }
    
    func slideViewVerticallyTo(_ y: CGFloat) {
        topPaddingConstraint?.constant = frame.height - y
    }
    
    @objc func didSummaryViewTapped(_ tapGesture: UITapGestureRecognizer) {
        popUpPlayerView()
    }
    
    @objc func didDeemedViewTapped(_ tapGesture: UITapGestureRecognizer) {
        popDownPlayerView()
    }
    
    public func popUpPlayerView() {
        deemedView.isHidden = false
        UIView.animate(withDuration: animationDuration) {
            self.slideViewVerticallyTo(self.topInsets + self.topPadding)
            self.miniSummaryBarView.alpha = 0.0
            self.deemedView.alpha = 0.7
        }
        isPoppedUp = true
    }
    
    public func popDownPlayerView() {
        UIView.animate(withDuration: animationDuration, animations: {
            self.miniSummaryBarView.alpha = 1.0
            self.slideViewVerticallyTo(self.frame.size.height - self.miniSummaryBarHeight)
            self.deemedView.alpha = 0.0
            }) { _ in
                self.deemedView.isHidden = true
        }
        
        isPoppedUp = false
    }
    
    @objc func onPan(_ panGesture: UIPanGestureRecognizer) {
        self.willPopClosure?(!isPoppedUp)
        let viewHeight = frame.size.height
        let translation = panGesture.translation(in: self)        
        
        switch panGesture.state {
        case .began, .changed:
            isPanning = true
            deemedView.isHidden = false
            let y = isPoppedUp ? max(topInsets, translation.y) : min(0, translation.y)
            
            if !isPoppedUp && (translation.y > 0 || viewHeight - miniSummaryBarHeight + y < topInsets + topPadding) {
                break
            }
            
            print(0.7 * (isPoppedUp ? (viewHeight - topPadding) - y : -y) / (viewHeight - topPadding), -y / (viewHeight - topPadding))
            deemedView.alpha = 0.7 * (isPoppedUp ? (viewHeight - topPadding) - y : -y) / (viewHeight - topPadding)
            miniSummaryBarView.alpha = (isPoppedUp ? y : (viewHeight - topPadding) + y) / (viewHeight - topPadding)
            slideViewVerticallyTo(isPoppedUp ? y + topPadding : viewHeight - miniSummaryBarHeight + y)
            break
        case .ended:
            isPanning = false
            let velocity = panGesture.velocity(in: self)
            let pop = (isPoppedUp ? translation.y > viewHeight * minimumScreenRatioToHide : translation.y < -viewHeight * minimumScreenRatioToHide ) ||
                (velocity.y > minimumVelocityToHide)
            print(translation.y)
            if pop {
                if isPoppedUp {
                    popDownPlayerView()
                } else {
                    popUpPlayerView()
                }
            } else {
                if isPoppedUp {
                    popUpPlayerView()
                } else {
                    popDownPlayerView()
                }
            }
            break
        default:
            isPanning = false
            if isPoppedUp {
                popUpPlayerView()
            } else {
                popDownPlayerView()
            }
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
}


extension PopupTableView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self {
            return nil
        }
        
        return view
    }
}

extension PopupTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}


extension PopupTableView: UITableViewDelegate {
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
