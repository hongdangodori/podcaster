//
//  PodcastPlayerView.swift
//  Podcaster
//
//  Created by Coupang on 2017. 12. 16..
//  Copyright © 2017년 Byoungho. All rights reserved.
//

import UIKit

class PopupSlideTableView: UIView {
    public let minimumVelocityToHide: CGFloat = 1500
    public let minimumScreenRatioToHide: CGFloat = 0.2
    public let animationDuration: TimeInterval = 0.3
    
    @IBOutlet weak var deemedView: UIView!
    
    public var miniSummaryBarHeight: CGFloat {
        didSet {
            miniSummaryBarHeightConstraint.constant = miniSummaryBarHeight
            heightConstraint?.constant = miniSummaryBarHeight
            topPaddingConstraint?.constant = miniSummaryBarHeight
        }
    }
    public let statusBarHeight = UIApplication.shared.statusBarFrame.height
    @IBOutlet weak var miniSummaryBarHeightConstraint: NSLayoutConstraint!
    
    private var topInsets: CGFloat {
        return -miniSummaryBarHeight + statusBarHeight
    }
    
    public var topPadding: CGFloat = 0 {
        didSet {
            if topPadding < 0 {
                topPadding = 0
            }
        }
    }
    
    public var bottomInsets: CGFloat = 0 {
        didSet {
            topPaddingConstraint?.constant = bottomInsets + miniSummaryBarHeight
        }
    }
    
    private var isPoppedUp: Bool = false
    private var isFull: Bool = false
    private var translationYWhenContentsOffSetZero: CGFloat = 0
    
    public var isFullPageEnabled: Bool = true
    
    private var fullPageEnabled: Bool {
        return topPadding > 0 && isFullPageEnabled
    }
    private var isPanning = false
    private var withDeemedView = false
    
    private var topPaddingConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    
    public var didPopClosure: ((_ isPopped: Bool) -> Void)?
    public var progressPopClosure: ((_ percentage: CGFloat) -> Void)?
    
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
    
    public weak var summaryBarView: UIView? = nil {
        willSet {
            if let summaryBarView = summaryBarView {
                miniSummaryBarView.removeConstraints(miniSummaryBarView.constraints.filter { $0.firstItem === summaryBarView || $0.secondItem === summaryBarView })
            }
            guard let newValue = newValue else { return }
            miniSummaryBarView.addSubview(newValue)
        }
        
        didSet {
            guard let summaryBarView = summaryBarView else { return }
            miniSummaryBarView.addConstraint(NSLayoutConstraint(item: miniSummaryBarView, attribute: .leading, relatedBy: .equal, toItem: summaryBarView, attribute: .leading, multiplier: 1.0, constant: 0.0))
            miniSummaryBarView.addConstraint(NSLayoutConstraint(item: miniSummaryBarView, attribute: .trailing, relatedBy: .equal, toItem: summaryBarView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
            miniSummaryBarView.addConstraint(NSLayoutConstraint(item: miniSummaryBarView, attribute: .top, relatedBy: .equal, toItem: summaryBarView, attribute: .top, multiplier: 1.0, constant: 0.0))
            miniSummaryBarView.addConstraint(NSLayoutConstraint(item: miniSummaryBarView, attribute: .bottom, relatedBy: .equal, toItem: summaryBarView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        }
    }
    
    init(miniPlayerHeight: CGFloat) {
        miniSummaryBarHeight = miniPlayerHeight
        super.init(frame: .zero)
        commitInit()
        miniSummaryBarHeightConstraint.constant = miniPlayerHeight
        heightConstraint?.constant = miniPlayerHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        miniSummaryBarHeight = 0
        miniSummaryBarHeightConstraint.constant = 0
        heightConstraint?.constant = 0
        super.init(coder: aDecoder)
        commitInit()
    }
    
    func commitInit() {
        Bundle.main.loadNibNamed("PopupSlideTableView", owner: self, options: nil)
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
        topPaddingConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: popupView, attribute: .top, multiplier: 1.0, constant: miniSummaryBarHeight + bottomInsets)
        addConstraint(topPaddingConstraint!)
        heightConstraint = NSLayoutConstraint(item: popupView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: miniSummaryBarHeight)
        addConstraint(heightConstraint!)
    }
    
    func slideViewVerticallyTo(_ y: CGFloat) {
        guard y >= topInsets || y <= bottomInsets else { return }
        popupView.center = CGPoint(x: popupView.bounds.width / 2, y: popupView.bounds.height / 2 + y)
    }
    
    @objc func didSummaryViewTapped(_ tapGesture: UITapGestureRecognizer) {
        popUpPlayerView(animated: true)
    }
    
    @objc func didDeemedViewTapped(_ tapGesture: UITapGestureRecognizer) {
        popDownPlayerView(animated: true)
    }
    
    public func popUpPlayerView(animated: Bool = false) {
        deemedView.isHidden = false
        didPopClosure?(true)
        if animated {
            UIView.animate(withDuration: animationDuration, animations: {
                self.slideViewVerticallyTo(self.topInsets + self.topPadding)
                self.miniSummaryBarView.alpha = 0.0
                self.deemedView.alpha = 0.7
                self.progressPopClosure?(0)
            }) { _ in
                self.translationYWhenContentsOffSetZero = 0
            }
        } else {
            slideViewVerticallyTo(topInsets + topPadding)
            miniSummaryBarView.alpha = 0.0
            deemedView.alpha = 0.7
            progressPopClosure?(0)
            translationYWhenContentsOffSetZero = 0
        }
        isPoppedUp = true
        isFull = false
    }
    
    public func popUpToFullPlayerView(animated: Bool = false) {
        didPopClosure?(true)
        progressPopClosure?(0)
        if animated {
            UIView.animate(withDuration: animationDuration, animations: {
                self.slideViewVerticallyTo(self.topInsets)
            }) { _ in
                self.translationYWhenContentsOffSetZero = 0
            }
        } else {
            slideViewVerticallyTo(topInsets)
            translationYWhenContentsOffSetZero = 0
        }
        isPoppedUp = true
        isFull = true
    }
    
    public func popDownPlayerView(animated: Bool = false) {
        if animated {
            UIView.animate(withDuration: animationDuration, animations: {
                self.miniSummaryBarView.alpha = 1.0
                self.slideViewVerticallyTo(self.frame.size.height - self.miniSummaryBarHeight - self.bottomInsets)
                self.deemedView.alpha = 0.0
                self.progressPopClosure?(100)
            }) { _ in
                self.deemedView.isHidden = true
                self.didPopClosure?(false)
                self.translationYWhenContentsOffSetZero = 0
            }
        } else {
            miniSummaryBarView.alpha = 1.0
            slideViewVerticallyTo(frame.size.height - miniSummaryBarHeight  - self.bottomInsets)
            deemedView.alpha = 0.0
            deemedView.isHidden = true
            didPopClosure?(false)
            progressPopClosure?(100)
            translationYWhenContentsOffSetZero = 0
        }

        isPoppedUp = false
    }
    
    @objc func onPan(_ panGesture: UIPanGestureRecognizer) {
        let viewHeight = frame.size.height
        let translation = panGesture.translation(in: self)        
        let translationY = translation.y - translationYWhenContentsOffSetZero
        
        switch panGesture.state {
        case .began, .changed:
            isPanning = true
            deemedView.isHidden = false
            var topMax: CGFloat = 0
            if fullPageEnabled {
                topMax -= topPadding
            }
            
            let y = isPoppedUp ? max(topMax, translationY) : min(0, translationY)
            
            if !isPoppedUp && (translationY > 0 || viewHeight - miniSummaryBarHeight + y < topInsets + topPadding ) {
                break
            }
            
            if isFull {
                slideViewVerticallyTo(y - miniSummaryBarHeight + statusBarHeight)
            } else if isPoppedUp {
                if y > 0 {
                    deemedView.alpha = 0.7 * (viewHeight - topPadding - y) / (viewHeight - topPadding)
                    miniSummaryBarView.alpha = y / (viewHeight - topPadding)
                    progressPopClosure?(100 * (1 - (viewHeight - topPadding - y) / (viewHeight - topPadding)))
                }
                slideViewVerticallyTo(y + topPadding - miniSummaryBarHeight + statusBarHeight)
            } else {
                didPopClosure?(true)
                deemedView.alpha = 0.7 *  -y / (viewHeight - topPadding)
                progressPopClosure?(100 * (1 - -y / (viewHeight - topPadding)))
                miniSummaryBarView.alpha = (viewHeight - topPadding + y) / (viewHeight - topPadding)
                slideViewVerticallyTo(viewHeight - miniSummaryBarHeight + y - bottomInsets)
            }
            break
        case .ended:
            isPanning = false
            let velocity = panGesture.velocity(in: self)
            let pop = (isPoppedUp ? translationY > viewHeight * minimumScreenRatioToHide : translationY < -viewHeight * minimumScreenRatioToHide ) ||
                (velocity.y > minimumVelocityToHide) || (fullPageEnabled && (isFull ? translationY > -topInsets : translationY < topInsets))
            if pop {
                if isFull {
                    popUpPlayerView(animated: true)
                } else {
                    if isPoppedUp {
                        if translationY < topInsets {
                            popUpToFullPlayerView(animated: true)
                        } else {
                            popDownPlayerView(animated: true)
                        }
                    } else {
                        popUpPlayerView(animated: true)
                    }
                }
            } else {
                if isFull {
                    popUpToFullPlayerView(animated: true)
                } else if isPoppedUp {
                    popUpPlayerView(animated: true)
                } else {
                    popDownPlayerView(animated: true)
                }
            }
            translationYWhenContentsOffSetZero = 0
            print("to Zero")
            break
        default:
            isPanning = false
            if isFull {
                popUpToFullPlayerView(animated: true)
            } else if isPoppedUp {
                popUpPlayerView(animated: true)
            } else {
                popDownPlayerView(animated: true)
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


extension PopupSlideTableView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self {
            return nil
        }
        
        return view
    }
}

extension PopupSlideTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .orange
        return cell
    }
}


extension PopupSlideTableView: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        if scrollOffset == 0 && translationYWhenContentsOffSetZero == 0 {
            translationYWhenContentsOffSetZero = scrollView.panGestureRecognizer.translation(in: self).y
            print(translationYWhenContentsOffSetZero)
        }
        
        if scrollOffset < 0 || isPanning {
            scrollView.contentOffset.y = 0
            onPan(scrollView.panGestureRecognizer)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let scrollOffset = scrollView.contentOffset.y
        if scrollOffset <= 0 || isPanning {
            onPan(scrollView.panGestureRecognizer)
        }
    }
}
