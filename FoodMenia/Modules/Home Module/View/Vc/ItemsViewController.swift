//
//  ItemsViewController.swift
//  FoodMenia
//
//  Created by Varinder on 07/08/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ItemsViewController: ViewController{
    
    @IBOutlet weak var totalValueLbl: UILabel!
    @IBOutlet weak var orderListTableView: UITableView!
    /// `presenter` `ref` in home view
    /// this will handle all the presenter calls
    var presenter: HomePresenterProtocol?
    
    /// dispose bag for releasing the memorny
    public var bag = DisposeBag()
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<Section>?

    //View:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTableViewWithDataSource()
        bindSelectedITems()
    }
    // -------- END
    
    //MARK:- back action
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// thiw will bind the `tableView` with selected items
    /// will helps to display all the `order` list
    private func bindTableViewWithDataSource() {
        orderListTableView.register(UINib(nibName: "OrderViewCell", bundle: nil), forCellReuseIdentifier: OrderViewCell.reuseIdentifier)
        if let items = self.presenter?.selectedItems {
            items.bind(to: orderListTableView.rx.items(cellIdentifier: OrderViewCell.reuseIdentifier, cellType: OrderViewCell.self)) { (row, model , cell) in
                 cell.configureCell(model)
                 cell.delegate = self
             }.disposed(by: bag)
            orderListTableView
                 .rx.delegate
                 .setForwardToDelegate(self, retainDelegate: false)
        }
    }
    
    // will bind the selected items
    private func bindSelectedITems() {
        presenter?.selectedItems?.asObservable().subscribe(onNext: { [weak self] item in
            if let items = self?.presenter?.selectedItems {
                let prices = items.value.compactMap({$0.itemPrice}).reduce(0,+)
                self?.totalValueLbl.text = "Value : \(prices) usd"
            }
        }).disposed(by: bag)
    }
}

//MARK:- UITableViewDelegate
extension ItemsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}

//MARK:-
extension ItemsViewController : OrderViewCellDelegate {
    func orderCellDidRemoveItem(foodItem: FoodItem) {
        if let index = self.presenter?.selectedItems?.value.firstIndex(of: foodItem) {
            UIAlertController.showAlert(title: "Delete!", message: "Are you sure you want to delete the \(foodItem.itemName!)", actions: ["Delete":.destructive,"Cancel":.default],from: self) { [weak self] action in
                if action.title == "Delete" {
                    self?.presenter?.selectedItems?.remove(at: index)
                    self?.orderListTableView.reloadData()
                    if let itemCount = self?.presenter?.selectedItems?.value.count {
                        if itemCount == 0 {
                            self?.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
}
