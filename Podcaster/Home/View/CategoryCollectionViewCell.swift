//
//  CategoryCollectionViewCell.swift
//  Podcaster
//
//  Created by 한병호 on 2017. 12. 26..
//  Copyright © 2017년 Byoungho. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTitleLabel.sizeToFit()
        // Initialization code
    }
}
