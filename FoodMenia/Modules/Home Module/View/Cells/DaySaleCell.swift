//
//  DaySaleCell.swift
//  FoodMenia
//
//  Created by Varinder on 06/08/21.
//

import UIKit

import SnapKit

class DaySaleCell: UICollectionViewCell,Reusable {
    
    
    @IBOutlet weak var saleImageView: UIImageView!
    @IBOutlet weak var imageHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// set up all the ui element with the size
    /// - Parameter size: canvas height/width for cell
    func updateUI(_ size: CGSize) {
        imageHeightConstarint.constant = size.height
        imageWidthConstraint.constant = size.width
        self.layoutIfNeeded()
    }
}
