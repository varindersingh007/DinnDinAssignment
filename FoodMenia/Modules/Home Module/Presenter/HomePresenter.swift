//
//  HomePresenter.swift
//  FoodMenia
//
//  Created by Varinder on 06/08/21.
//

import Foundation
import RxCocoa

class HomePresenter: HomePresenterProtocol {
    
    var selectedItems: BehaviorRelay<[FoodItem]>?
    
    /// reference to `router`in `presenter`
    /// this will helps to navigate to other `views`
    var router: HomeRouter?
    
    /// ref to `interactor` in presenter
    /// this will interacte with `bussiness logic`
    var interactor: HomeInteractorProtocol? 
    
    /// ref to `HomeVc` for updates
    /// this will allow to pass calls directly to view by `presenter`
    var homeView: HomeViewProtocol?

    ///
    /// this will pass the response to view , when ever `interactor` finishes the fetchind data
    /// - Parameter results: will include `success` and `failure` block
    /// - sucess : will contain `daySales` to show top swipe
    /// - failur : this will come up with `webError` so show error message to a user
    /// ---
    func didFinishFetchingDaySales(results: Result<DaySalesBase,WebError>) {
        switch results {
        case .success( let daySalesBase):
            if let daySales = daySalesBase.daySales {
                homeView?.updateDaySales(daySales)
            }
        case .failure(let error):
            homeView?.showError(error)
        }
    }

    ///
    /// this will pass the response to view , when ever `interactor` finishes the fetchind data
    /// - Parameter results: will include `success` and `failure` block
    /// - sucess : will contain `Foods` to show food items
    /// - failur : this will come up with `webError` so show error message to a user
    /// ---
    func didFinishFetchingFoods(results: Result<FoodBaseModel,WebError>) {
        switch results {
        case .success( let foodOrDrinks):
            if let fooddrinks = foodOrDrinks.foodsDrinks {
                for item in fooddrinks {
                    guard let type = FoodItemType(rawValue: item.name ?? "") else { return }
                    switch type {
                    case .pizza:
                        if let foodItems = item.foodItems {
                            homeView?.updatePizzaItems(foodItems)
                        }
                    case .sushi:
                        if let foodItems = item.foodItems {
                            homeView?.updateSushiItems(foodItems)
                        }
                    case .drinks:
                        if let foodItems = item.foodItems {
                            homeView?.updateDrinksItems(foodItems)
                        }
                    }
                }
            }
        case .failure(let error):
            homeView?.showError(error)
        }
    }
    
    /// when `HomeView` stored in memory this will helps to tell the `interactor` to start fetching data
    func startFetchingData() {
        DispatchQueue.global(qos: .background).async {
            self.interactor?.fetchDaySales()
            self.interactor?.fetchFoods()
        }
    }    
    
    /// on order list vc user can remove the selected items
    /// - Parameters:
    ///   - foodItem: specific item which need to remove from the list
    ///   - vc: this is the `ItemsViewController` where use can reomve the order
    ///    /// this will helps to remove item from the `selectedItems`
    func didRemoveITem( foodItem: FoodItem, vc: ItemsViewController) {
        self.homeView?.didRemoveITem(foodItem: foodItem, vc: vc)
    }
}
