//
//  HomeViewController.swift
//  FoodMenia
//
//  Created by Varinder on 06/08/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

/// A channels view controller.
class HomeViewController: UIViewController, HomeViewProtocol {
    /// `presenter` `ref` in home view
    /// this will handle all the presenter calls
    var presenter: HomePresenterProtocol?
    
    /*let dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, FoodItem>>(
      configureCell: { (_, collectionView, indexPath, item: FoodItem) in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodItemCell.reuseIdentifier, for: indexPath) as! FoodItemCell
        cell.configureCell(item)
        return cell
      },
        configureSupplementaryView: { _, _, _, _ in UICollectionReusableView(frame: CGRect(x: 0, y: 0, width: Utils.shared.screenWidth, height: 200)) }
    )*/

    
    public var bag = DisposeBag()
    
//    private(set) var daySales = BehaviorRelay<[DaySales]>(value: [])
//    private(set) var pizzaItems = BehaviorRelay<[FoodItem]>(value: [])
//    private(set) var sushiItems = BehaviorRelay<[FoodItem]>(value: [])
//    private(set) var drinksItems = BehaviorRelay<[FoodItem]>(value: [])
    
    private(set) var daySales = BehaviorRelay<[DaySales]>(value: [])
    private(set) var pizzaItems = [FoodItem]()
    private(set) var sushiItems = [FoodItem]()
    private(set) var drinksItems = [FoodItem]()
    
    
    private(set) var pizzaSection = BehaviorRelay<[Section]>(value: [])
    private(set) var sushiSection = BehaviorRelay<[Section]>(value: [])
    private(set) var drinksSection = BehaviorRelay<[Section]>(value: [])


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
    @IBOutlet weak var pageController: UIPageControl!
    
    var foodListDisplayIndex = 0
        
    var initialTop: CGFloat! {
        (Utils.shared.screenHeight * 0.75) - 70
    }
    
    var isMovingTop = false
    
    typealias Section = AnimatableSectionModel<String, FoodItem>
    private var dataSource = RxCollectionViewSectionedAnimatedDataSource<Section>( configureCell: { (_,_,_,_) in
        fatalError()
    },configureSupplementaryView: { (_,_,_,_) in
      fatalError()
    })
    
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
        bindPageControl()
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
        
        print("inital content off set ==> ",pizzaCollectionView.contentOffset)
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
        presenter?.selectedItems = BehaviorRelay<[FoodItem]>(value: [])
        presenter?.selectedItems?.asObservable().subscribe(onNext: { [weak self] item in
            if let count = self?.presenter?.selectedItems?.value.count {
                self?.cartItemCountBackView.isHidden = count == 0
                self?.cartItemCounter.text = "\(count)"
                self?.cartItemCountBackView.dumpingAnimation(from: 1, to: 1.02)
            }
        }).disposed(by: bag)
    }
    
    private func bindPageControl() {
        daySaleCollectionView.rx.didScroll
            .withLatestFrom(daySaleCollectionView.rx.contentOffset)
            .map { Int(round($0.x / self.daySaleCollectionView.frame.width)) }
            .bind(to: self.pageController.rx.currentPage)
            .disposed(by: bag)
    }
    
    private func bindFoodsCollectionView() {
        // 0. pizza collection view
        bindCollectionView(pizzaCollectionView, pizzaItems,pizzaSection)
        bindCollectionView(sushiCollectionView, sushiItems,sushiSection)
        bindCollectionView(drinksCollectionView, drinksItems,drinksSection)
    }
    
    func collectionViewDataSourceUI() -> (
            CollectionViewSectionedDataSource<Section>.ConfigureCell,
            CollectionViewSectionedDataSource<Section>.ConfigureSupplementaryView
        ) {
        return (
             { _, cv, ip, i in
                let cell = cv.dequeueReusableCell(withReuseIdentifier: FoodItemCell.reuseIdentifier, for: ip) as! FoodItemCell
                cell.configureCell(i)
                cell.delegate = self
                return cell
            },
             { ds ,cv, kind, ip in
                print("ip for secion",ip)
                if kind == UICollectionView.elementKindSectionHeader {
                let section = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FoodHeaderView.reuseIdentifier, for: ip) as! FoodHeaderView
                    section.configureHeader(cv.tag)
                return section
                } else {
                    return UICollectionReusableView()
                }
            }
        )
    }
    
    func bindCollectionView(_ collectionView: UICollectionView, _ items: [FoodItem],_ section: BehaviorRelay<[Section]>) {
        
        collectionView.register(UINib(nibName: "FoodItemCell", bundle: nil), forCellWithReuseIdentifier: FoodItemCell.reuseIdentifier)
        collectionView.register(UINib(nibName: "FoodHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FoodHeaderView.reuseIdentifier)
        
        let (configureCollectionViewCell, configureSupplementaryView) =  self.collectionViewDataSourceUI()
        let cvAnimatedDataSource = RxCollectionViewSectionedAnimatedDataSource(
            configureCell: configureCollectionViewCell,
            configureSupplementaryView: configureSupplementaryView
        )

        section
            .bind(to: collectionView.rx.items(dataSource: cvAnimatedDataSource))
            .disposed(by: bag)
        collectionView.rx.setDelegate(self).disposed(by: bag)
        
        Observable.of(
            collectionView.rx.modelSelected(FoodItem.self)
        )
            .merge()
            .subscribe(onNext: { item in
                print("Let me guess, it's .... It's \(item), isn't it? Yeah, I've got it.")
            })
            .disposed(by: bag)
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
            self.pizzaItems = pizzas
            let secion2 = Section(model: "Pizza", items: pizzas)
            self.pizzaSection.append(secion2)
        }
    }
    
    ///
    /// view protocol will notify the view about the new `pizaa`
    /// - Parameter foods: include all the `pizza` to update home view
    ///
    func updateSushiItems(_ sushis: [FoodItem]) {
        DispatchQueue.main.async {
            self.sushiItems = sushis
            let secion2 = Section(model: "Sushi", items: sushis)
            self.sushiSection.append(secion2)

        }
    }
    
    ///
    /// view protocol will notify the view about the new `pizaa`
    /// - Parameter foods: include all the `pizza` to update home view
    ///
    func updateDrinksItems(_ drinks: [FoodItem]) {
        DispatchQueue.main.async {
            self.drinksItems = drinks
            let secion2 = Section(model: "Drink", items: drinks)
            self.drinksSection.append(secion2)

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
        //if !canPerformGesture { return }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width * 0.32)
    }
}

//MARK:- UIScrollViewDelegate
extension HomeViewController : UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        foodListDisplayIndex = Int(scrollView.contentOffset.x / Utils.shared.screenWidth)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if  scrollView == mainScrollView {
            let newIndex = Int(scrollView.contentOffset.x / Utils.shared.screenWidth)
            if newIndex != foodListDisplayIndex {
             // new index here
                foodListDisplayIndex = newIndex
            }
        }
        
        /*  if scrollView == pizzaCollectionView ||
            scrollView == sushiCollectionView ||
            scrollView == drinksCollectionView {
            let yPos = scrollView.contentOffset.y
            print("content off set",yPos)
           if yPos < -47 {
                foodListTopConstraint.constant = initialTop
                scrollView.setContentOffset(.zero, animated: false)
                mainScrollView.isUserInteractionEnabled = false
                enableCollectionScrolling(false)
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }*/
//        }
    }
}

//MARK:- FoodItemCellDelegate
extension HomeViewController: FoodItemCellDelegate {
    func cellDidSelectFoodItem(_ foodItem: FoodItem) {
        presenter?.selectedItems?.append(foodItem)
    }
}
/*
extension HomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if pizzaCollectionView.contentOffset.y < -45 {
            enableCollectionScrolling(false)
            enableCollectionScrolling(false)
            return false
        }
        return true
    }
}*/
