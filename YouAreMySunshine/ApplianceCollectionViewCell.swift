//
//  ApplianceCollectionViewCell.swift
//  YouAreMySunshine
//
//  Created by Joseph Erlandson on 4/29/17.
//  Copyright © 2017 JosephErlandson. All rights reserved.
//

import UIKit

class ApplianceCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var applianceLabel: UILabel!
    @IBOutlet weak var applianceImageView: UIImageView!
    @IBOutlet weak var selectedImageView: UIView!
    @IBOutlet weak var checkImageView: UIImageView! {
        didSet {
            checkImageView.image = UIImage(named: "check")?.maskWithColor(color: UIColor.white)
        }
    }
    override var isSelected: Bool {
        didSet {
            selectedImageView.alpha = isSelected ? 1.0 : 0.0
        }
    }

}
