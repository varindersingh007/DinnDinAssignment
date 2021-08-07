//
//  FoodHeaderView.swift
//  FoodMenia
//
//  Created by Varinder on 06/08/21.
//

import UIKit

class FoodHeaderView: UICollectionReusableView, Reusable {
   
    
    @IBOutlet var topMenuLables: [UILabel]!
    
    @IBOutlet var filterItemLables: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        filterItemLables.forEach { lable in
            lable.roundCorner(lable.frame.height / 2)
            lable.setBorder(width: 1, color: UIColor.darkGray)
        }
    }
    
    func configureHeader(_ sectionIndex: Int) {
        print("section for header",sectionIndex)
        topMenuLables.forEach { lable in
            lable.textColor = sectionIndex == lable.tag ? .black : .lightGray
        }
    }
    
    func reset() {
        
    }
    
}
