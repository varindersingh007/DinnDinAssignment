//
//  HomeRouter.swift
//  FoodMenia
//
//  Created by Varinder on 06/08/21.
//

import Foundation

class HomeRouter {
    
    /// having a `ref` to the `homeView` as a `entryPoint`
    var entry: EntryPoint?
    
    /// start will provide the `router` as inital `HomeView`
    static func start() -> HomeRouter {
        let router = HomeRouter()
        
        let view: HomeViewProtocol = Storyboards.main.instantiateInitialViewController() as! HomeViewController
        let presenter: HomePresenterProtocol = HomePresenter()
        let interactor: HomeInteractorProtocol = HomeInteractor()
        
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.homeView = view
        presenter.router = router
        presenter.interactor = interactor
        router.entry = view as? EntryPoint
        return router
    }
    
    func viewOrders(_ presenter: HomePresenter) {
        
    }
    
}
