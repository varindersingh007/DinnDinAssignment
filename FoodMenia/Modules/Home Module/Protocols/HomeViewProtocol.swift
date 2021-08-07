//
//  HomeViewProtocol.swift
//  FoodMenia
//
//  Created by Varinder on 06/08/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

/// initial `App` entry point
typealias EntryPoint = HomeViewProtocol & UIViewController
/// `converable` for section model
/// this will helps to define section in data source
typealias Section = AnimatableSectionModel<String, FoodItem>


protocol Reusable {
    /// The reuse identifier to use when registering and later dequeuing a reusable cell.
    static var reuseIdentifier: String { get }
    
}

extension Reusable {
    /// By default, use the name of the class as String for its reuseIdentifier.
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}


/// these are the items types need to display
enum FoodItemType: String {
    case pizza = "Pizza"
    case sushi = "Sushi"
    case drinks = "Drinks"
}


/// `view` protocol foe `homeVC`
protocol HomeViewProtocol: AnyObject {
    
    /// `presenter` `ref` in home view
    /// this will handle all the presenter calls
    var presenter: HomePresenterProtocol? { get set }
    
    ///
    /// view protocol will notify the view about the new `daySales`
    /// - Parameter daySales: include all the `daySales` to update home view
    ///
    func updateDaySales(_ daySales: [DaySales])
    
    ///
    /// view protocol will notify the view about the new `pizaa`
    /// - Parameter foods: include all the `pizza` to update home view
    ///
    func updatePizzaItems(_ pizzas: [FoodItem])
    
    ///
    /// view protocol will notify the view about the new `pizaa`
    /// - Parameter foods: include all the `pizza` to update home view
    ///
    func updateSushiItems(_ sushis: [FoodItem])
    
    ///
    /// view protocol will notify the view about the new `pizaa`
    /// - Parameter foods: include all the `pizza` to update home view
    ///
    func updateDrinksItems(_ drinks: [FoodItem])
    
    ///
    /// view protocol will notify the view about coming errors
    /// - Parameter error: is a custom `webError`, including error `details`
    /// - statusCode: to check the specific reason for the error
    /// - message: specific `message` for the `error`
    func showError(_ error: WebError)
    
    /// on order list vc user can remove the selected items
    /// - Parameters:
    ///   - foodItem: specific item which need to remove from the list
    ///   - vc: this is the `ItemsViewController` where use can reomve the order
    ///    /// this will helps to remove item from the `selectedItems`
    func didRemoveITem( foodItem: FoodItem, vc: ItemsViewController)
    
}



/// custom error for our modeling
enum WebError: Error {
    case failed(String)
}


/// presenter will present the `view`
protocol HomePresenterProtocol: AnyObject {
    
    /// reference to `router`in `presenter`
    /// this will helps to navigate to other `views`
    var router: HomeRouter? { get set }
    
    /// ref to `interactor` in presenter
    /// this will interacte with `bussiness logic`
    var interactor: HomeInteractorProtocol? { get set }
    
    /// ref to `HomeVc` for updates
    /// this will allow to pass calls directly to view by `presenter`
    var homeView: HomeViewProtocol? { get set }
    
    /// this will helps to store selected items
    /// 
    var selectedItems : BehaviorRelay<[FoodItem]>? { get set }
    
    ///
    /// this will pass the response to view , when ever `interactor` finishes the fetchind data
    /// - Parameter results: will include `success` and `failure` block
    /// - sucess : will contain `daySales` to show top swipe
    /// - failur : this will come up with `webError` so show error message to a user
    /// ---
    func didFinishFetchingDaySales(results: Result<DaySalesBase,WebError>)

    ///
    /// this will pass the response to view , when ever `interactor` finishes the fetchind data
    /// - Parameter results: will include `success` and `failure` block
    /// - sucess : will contain `Foods` to show food items
    /// - failur : this will come up with `webError` so show error message to a user
    /// ---
    func didFinishFetchingFoods(results: Result<FoodBaseModel,WebError>)
    
    
    /// when `HomeView` stored in memory this will helps to tell the `interactor` to start fetching data 
    func startFetchingData()
    
    /// on order list vc user can remove the selected items
    /// - Parameters:
    ///   - foodItem: specific item which need to remove from the list
    ///   - vc: this is the `ItemsViewController` where use can reomve the order
    ///    /// this will helps to remove item from the `selectedItems`
    func didRemoveITem( foodItem: FoodItem, vc: ItemsViewController)
}





/// home `interactor` protocol
/// this will work for `business` logic, like fetching data etc.
protocol HomeInteractorProtocol: AnyObject {
    
    /// this needs to have `presenter` ref in if
    /// interactor will directly interact with `presenter` to give updates about the data fetching
    /// this have `getter`  `setter `
    var presenter: HomePresenterProtocol? { get set }
    
    
    /// this will fetch the `daySales` for home view
    /// after fetching the daySales , this wil notifiy the `presenter` to udpate the `homeView`
    func fetchDaySales()
    
    /// this will fetch the `Foods&Drinks` for home view listing
    /// after fetching the foodsAndDrings , this wil notifiy the `presenter` to udpate the `homeView`
    func fetchFoods()
}


/// `router` protocol
/// this will handle the `navigaton` process for `homeView`
protocol HomeRouterProtocol:AnyObject {
    
    /// having a `ref` to the `homeView` as a `entryPoint`
    var entry : EntryPoint? { get set }
        
    /// start will provide the `router` as inital `HomeView`
    static func start() -> HomeRouter
}
