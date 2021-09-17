//
//  HomeInterator.swift
//  FoodMenia
//
//  Created by Varinder on 06/08/21.
//

import Foundation
class HomeInteractor: HomeInteractorProtocol {
    
    
    /// this needs to have `presenter` ref in if
    /// interactor will directly interact with `presenter` to give updates about the data fetching
    /// this have `getter`  `setter `
    var presenter: HomePresenterProtocol?
    
    
    /// this will fetch the `daySales` for home view
    /// after fetching the daySales , this wil notifiy the `presenter` to udpate the `homeView`
    func fetchDaySales() {
        WebService.shared.fetchData(endPointType: FoodEndPointType.daySales) { [weak self] (results: Result<DaySalesBase,WebError>
        ) in
            self?.presenter?.didFinishFetchingDaySales(results: results)
        }
    }
    
    /// this will fetch the `foodsAndDringks` for home view listing
    /// after fetching the foodsAndDrings , this wil notifiy the `presenter` to udpate the `homeView`
    func fetchFoods() {
        WebService.shared.fetchData(endPointType: FoodEndPointType.foodDrinks) { [weak self] (results: Result<FoodBaseModel,WebError>
        ) in
            self?.presenter?.didFinishFetchingFoods(results: results)
        }
    }
}
