//
//  CategoryLinearTableViewCell.swift
//  Podcaster
//
//  Created by Coupang on 2018. 1. 4..
//  Copyright © 2018년 Byoungho. All rights reserved.
//

import UIKit

class CategoryLinearTableViewCell: UITableViewCell {

    @IBOutlet weak var subscriptionButton: UIButton!
    var isSubscribed: Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let subscriptionImage = UIImage(named: "auto_subscriptions")?.withRenderingMode(.alwaysTemplate)
        let checkedSubscriptionImage = UIImage(named: "ic_checked_subscriptions")?.withRenderingMode(.alwaysTemplate)
        
        subscriptionButton.setImage(checkedSubscriptionImage, for: .selected)
        subscriptionButton.setImage(subscriptionImage, for: .normal)
        
        if isSubscribed {
            subscriptionButton.isSelected = true
            subscriptionButton.tintColor = UIColor.gray
        } else {
            subscriptionButton.isSelected = false
            subscriptionButton.tintColor = UIColor.orange
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didSubscriptionButtonTapped(_ sender: Any) {
        isSubscribed = !isSubscribed
        if isSubscribed {
            subscriptionButton.isSelected = true
            subscriptionButton.tintColor = UIColor.gray
        } else {
            subscriptionButton.isSelected = false
            subscriptionButton.tintColor = UIColor.orange
        }
    }
}
