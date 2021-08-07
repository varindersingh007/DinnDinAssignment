//
//  OrderViewCell.swift
//  FoodMenia
//
//  Created by Varinder on 07/08/21.
//

import UIKit
import RxSwift

protocol OrderViewCellDelegate: AnyObject {
    func orderCellDidRemoveItem(foodItem: FoodItem)
}

class OrderViewCell: UITableViewCell,Reusable {

    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var itemPriceLbl: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    weak var delegate : OrderViewCellDelegate?
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(_ foodItem: FoodItem) {
        self.itemNameLbl.text = foodItem.itemName
        self.itemPriceLbl.text = "\(foodItem.itemPrice ?? 0) usd"
        if let imageName = foodItem.itemImage {
            self.itemImageView.image = UIImage(named: imageName)
        }
        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.delegate?.orderCellDidRemoveItem(foodItem: foodItem)
        }).disposed(by: disposeBag)
    }
}
