//
//  NowPlayingView.swift
//  Podcaster
//
//  Created by Coupang on 2017. 12. 17..
//  Copyright © 2017년 Byoungho. All rights reserved.
//

import UIKit

class NowPlayingView: UIView {
    
    @IBOutlet var containerView: UIView!
    var didCloseButtonTouched: (() -> Void)?
    
    @IBOutlet weak var podImageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        Bundle.main.loadNibNamed("NowPlayingView", owner: self, options: nil)
        translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: 0))
        podImageView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.borderWidth = 0.4
    }
    
    @IBAction func didCloseButtonTouched(_ sender: Any) {
        didCloseButtonTouched?()
    }
}
