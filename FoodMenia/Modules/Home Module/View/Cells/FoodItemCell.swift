//
//  FoodItemCell.swift
//  FoodMenia
//
//  Created by Varinder on 06/08/21.
//

import UIKit
import RxSwift
import RxCocoa

protocol FoodItemCellDelegate: AnyObject {
    func cellDidSelectFoodItem(_ foodItem: FoodItem)
}


class FoodItemCell: UICollectionViewCell, Reusable {
   
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemThumView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemDetailsLbl: UILabel!
    @IBOutlet weak var itemWeightLbl: UILabel!
    @IBOutlet weak var itemAddButton: UIButton!
    @IBOutlet weak var vegSelectionView: UIView!
    weak var delegate : FoodItemCellDelegate?
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        widthConstraint?.constant = Utils.shared.screenWidth - 40
        self.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        vegSelectionView.roundCorner(5)
        mainView?.roundCorner(20)
        mainView.roundCorner(20)
        mainView.showShadow(color: UIColor.lightGray, offset: CGSize(width: 1, height: 1), radius: 5)
        itemThumView.roundCorners(corners: [.topLeft,.topRight], radius: 20)
        itemAddButton.roundCorner(itemAddButton.frame.height / 2)
    }

    func configureCell(_ foodItem: FoodItem) {
        if let imageName = foodItem.itemImage {
            itemThumView.image = UIImage(named: imageName)
        }
        itemNameLbl.text = foodItem.itemName
        itemDetailsLbl.text = foodItem.itemDetail
        if let price = foodItem.itemPrice {
            itemAddButton.setTitle("\(price) usd", for: .normal)
        }
        itemWeightLbl.text = foodItem.itemWeight
        vegSelectionView.isHidden = foodItem.isVeg ?? true
        itemAddButton.rx.tap.subscribe(onNext: { [weak self] in
            
            self?.animateAddItem()
            self?.delegate?.cellDidSelectFoodItem(foodItem)
        }).disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func animateAddItem() {
        let previousTitle = itemAddButton.titleLabel?.text
        self.itemAddButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.itemAddButton.backgroundColor = .systemGreen
            self.itemAddButton.setTitleColor(.white, for: .normal)
            self.itemAddButton.setTitle("Added + 1", for: .normal)
        } completion: { finished in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                DispatchQueue.main.async {
                    self.itemAddButton.backgroundColor = .black
                    self.itemAddButton.isUserInteractionEnabled = true
                    self.itemAddButton.setTitle(previousTitle, for: .normal)
                    self.itemAddButton.setTitleColor(.white, for: .normal)
                }
            }
        }
    }
    
    func reset() {
        
    }
}
