//
//  HomeViewController.swift
//  FoodMenia
//
//  Created by Varinder on 06/08/21.
//

import UIKit
import RxSwift
import RxCocoa

/// A channels view controller.
class HomeViewController: UIViewController, HomeViewProtocol {
    /// `presenter` `ref` in home view
    /// this will handle all the presenter calls
    var presenter: HomePresenterProtocol?
    
    public var bag = DisposeBag()
    
    private(set) var daySales = BehaviorRelay<[DaySales]>(value: [])
    private(set) var pizzaItems = BehaviorRelay<[FoodItem]>(value: [])
    private(set) var sushiItems = BehaviorRelay<[FoodItem]>(value: [])
    private(set) var drinksItems = BehaviorRelay<[FoodItem]>(value: [])
    
    /// this will helps to store selected items
    private(set) var selectedItems = BehaviorRelay<[FoodItem]>(value: [])


    @IBOutlet weak var daySaleCollectionView: UICollectionView!
    @IBOutlet weak var foodListBackView: UIView!
    @IBOutlet weak var foodListTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var pizzaCollectionView: UICollectionView!
    @IBOutlet weak var sushiCollectionView: UICollectionView!
    @IBOutlet weak var drinksCollectionView: UICollectionView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var cartItemCountBackView: UIView!
    @IBOutlet weak var cartItemCounter: UILabel!
    
    var initialTop: CGFloat! {
        (Utils.shared.screenHeight * 0.75) - 70
    }
    
    var isMovingTop = false
    
    var canPerformGesture: Bool! {
        !pizzaCollectionView.isUserInteractionEnabled || !sushiCollectionView.isUserInteractionEnabled || !drinksCollectionView.isUserInteractionEnabled
    }
    
    //MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // add gesture
        addGestures()
        bindDaysCollectionView()
        bindFoodsCollectionView()
        foodListTopConstraint.constant = initialTop
        self.view.layoutIfNeeded()
        bindSelectedItems()
        self.presenter?.startFetchingData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cartItemCountBackView.roundCorner(cartItemCountBackView.frame.height / 2)
        foodListBackView.roundCorners(corners: [.topLeft,.topRight], radius: 30)
        cartButton.roundCorner(cartButton.frame.height/2)
        cartButton.showShadow(color: UIColor.lightGray, offset: CGSize(width: 1, height: 1), radius: 5)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    // --------  END -------- //
    
    /// helps to bind the `daysColletion` to items
    /// reactive Swift will helps to make changes , whenever`daySale` will be changed
    /// here we will set the data to our days collection
    private func bindDaysCollectionView() {
        daySaleCollectionView.register(UINib(nibName: "DaySaleCell", bundle: nil), forCellWithReuseIdentifier: DaySaleCell.reuseIdentifier)
        daySales.bind(to: daySaleCollectionView.rx.items(cellIdentifier: DaySaleCell.reuseIdentifier, cellType: DaySaleCell.self)) { (row, model , cell) in
            cell.updateUI(self.daySaleCollectionView.bounds.size)
            cell.saleImageView.image = UIImage(named: model.imageName ?? "")
        }.disposed(by: bag)
    }
    
    /// will add `pan` gesture to `food` list view
    private func addGestures() {
        let panGesture = UIPanGestureRecognizer()//(target: self, action: #selector(self.handleFoodListSwiping(_:)))
        self.foodListBackView.addGestureRecognizer(panGesture)
        panGesture.rx.event.bind { [weak self] panGesture in
            self?.handleFoodListSwiping(panGesture)
        }.disposed(by: bag)
    }
    
    func bindSelectedItems() {
        selectedItems.asObservable().subscribe(onNext: { [weak self] item in
            if let count = self?.selectedItems.value.count {
                self?.cartItemCountBackView.isHidden = count == 0
                self?.cartItemCounter.text = "\(count)"
                self?.cartItemCountBackView.dumpingAnimation(from: 1, to: 1.02)
            }
        }).disposed(by: bag)
    }
    
    private func bindFoodsCollectionView() {
        // 0. pizza collection view
        bindCollectionView(pizzaCollectionView, pizzaItems)
        bindCollectionView(sushiCollectionView, sushiItems)
        bindCollectionView(drinksCollectionView, drinksItems)
    }
    
    func bindCollectionView(_ collectionView: UICollectionView, _ items: BehaviorRelay<[FoodItem]>) {
        collectionView.register(UINib(nibName: "FoodItemCell", bundle: nil), forCellWithReuseIdentifier: FoodItemCell.reuseIdentifier)
        items.bind(to: collectionView.rx.items(cellIdentifier: FoodItemCell.reuseIdentifier, cellType: FoodItemCell.self)) { (row, model , cell) in
            cell.configureCell(model)
            cell.delegate = self
        }.disposed(by: bag)
        collectionView
            .rx.delegate
            .setForwardToDelegate(self, retainDelegate: false)
    }
    
    ///
    /// view protocol will notify the view about the new `daySales`
    /// - Parameter daySales: include all the `daySales` to update home view
    ///
    func updateDaySales(_ daySales: [DaySales]) {
        DispatchQueue.main.async {
            self.daySales.accept(daySales)
        }
    }
    
    ///
    /// view protocol will notify the view about the new `pizaa`
    /// - Parameter foods: include all the `pizza` to update home view
    ///
    func updatePizzaItems(_ pizzas: [FoodItem]) {
        DispatchQueue.main.async {
            self.pizzaItems.accept(pizzas)
        }
    }
    
    ///
    /// view protocol will notify the view about the new `pizaa`
    /// - Parameter foods: include all the `pizza` to update home view
    ///
    func updateSushiItems(_ sushis: [FoodItem]) {
        DispatchQueue.main.async {
            self.sushiItems.accept(sushis)
        }
    }
    
    ///
    /// view protocol will notify the view about the new `pizaa`
    /// - Parameter foods: include all the `pizza` to update home view
    ///
    func updateDrinksItems(_ drinks: [FoodItem]) {
        DispatchQueue.main.async {
            self.drinksItems.accept(drinks)
        }
    }
    
    ///
    /// view protocol will notify the view about coming errors
    /// - Parameter error: is a custom `webError`, including error `details`
    /// - statusCode: to check the specific reason for the error
    /// - message: specific `message` for the `error`
    func showError(_ error: WebError) {
        
    }
}

//MARK:- food list swipe handling
extension HomeViewController {
     func handleFoodListSwiping(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: foodListBackView)
        // handle the gesture state
        switch gesture.state {
        case .possible:
            break
        case .began:
            break
        case .changed:
            handleFoodSwiping(translation.y)
            self.calculateAlpha()
            break
        case .ended:
            if isMovingTop {
                foodListTopConstraint.constant = 0
                enableCollectionScrolling(true)
                mainScrollView.isUserInteractionEnabled = true
            } else {
                if foodListTopConstraint.constant > initialTop * 0.3 {
                    foodListTopConstraint.constant = initialTop
                    mainScrollView.isUserInteractionEnabled = false
                    enableCollectionScrolling(false)
                    calculateAlpha()
                } else {
                    foodListTopConstraint.constant = 0
                    enableCollectionScrolling(true)
                    mainScrollView.isUserInteractionEnabled = true
                }
            }
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            } completion: { finished in
                if finished {
                }
            }
           break
        case .cancelled:
            print("pan gesture cancelled")
            
            break
        case .failed:
            print("pan gesture failed")
            break
        @unknown default:
            break
        }
        gesture.setTranslation(CGPoint.zero, in: foodListBackView)
    }
    
    func handleFoodSwiping(_ top: CGFloat) {
        if !canPerformGesture { return }
        if top > 0 {
            print("Moving bottom")
            isMovingTop = false
        } else {
            print("moving top")
            isMovingTop = true
        }
        let newTop = foodListTopConstraint.constant + top
        print("leading translation for swipe ==> ",newTop)
        
        if Utils.shared.hasNotch && newTop <= 1 {
            enableCollectionScrolling(true)
            mainScrollView.isUserInteractionEnabled = true
            return
        }
        if newTop >= initialTop {
            mainScrollView.isUserInteractionEnabled = false
            return
        }
        foodListTopConstraint.constant =  newTop
    }
    
    func calculateAlpha() {
        let top = foodListTopConstraint.constant
        let percentage = (top*100)/initialTop
        self.daySaleCollectionView.alpha = percentage/100
    }
    
    func enableCollectionScrolling(_ enable:Bool) {
        pizzaCollectionView.isUserInteractionEnabled = enable
        sushiCollectionView.isUserInteractionEnabled = enable
        drinksCollectionView.isUserInteractionEnabled = enable
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension HomeViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width * 1.2)
    }
}

//MARK:- UIScrollViewDelegate
extension HomeViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == pizzaCollectionView ||
            scrollView == sushiCollectionView ||
            scrollView == drinksCollectionView {
            let yPos = scrollView.contentOffset.y
            print("content off set",yPos)
            if yPos < -45 {
                print("going down")
                enableCollectionScrolling(false)
            } else {
                print("Going top")
                enableCollectionScrolling(true)
            }
        }
    }
}

//MARK:- FoodItemCellDelegate
extension HomeViewController: FoodItemCellDelegate {
    func cellDidSelectFoodItem(_ foodItem: FoodItem) {
            selectedItems.append(foodItem)
        
    }
}
