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
    
    func updateUI(_ size: CGSize) {
        print(size)
        imageHeightConstarint.constant = size.height
        imageWidthConstraint.constant = size.width
        self.layoutIfNeeded()
      /*  saleImageView.snp.makeConstraints() { updator in
            updator.width.equalTo(size.width)
            updator.height.equalTo(size.height)
            updator.centerY.equalToSuperview()
            updator.centerX.equalToSuperview()
        }*/
    }

    
    func reset() {
        
    }
}
