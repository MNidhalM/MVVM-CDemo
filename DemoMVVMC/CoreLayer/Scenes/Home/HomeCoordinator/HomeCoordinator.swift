//
//  HomeCoordinator.swift
//  DemoMVVMC
//
//  Created by mac on 25/2/2022.
//

import UIKit
import Combine


final class HomeCoordinator: Coordinator {
    
    // MARK: - Properties
    let rootViewController: UINavigationController
    let storyboard = "Home"
    
    public weak var delegate: HomeCoordinatorDelegate?
    
    
    let sneakerService: SneakerService = {
        return SneakerService()
    }()
    
    
    // MARK: ViewModels
    lazy var homeViewModel: HomeViewModel! = {
        let viewModel = HomeViewModel(userViewModel: UserViewModel(), sneakerStore: sneakerService)
        viewModel.coordinatorDelegate = self
        return viewModel
    }()
    
    var detailsViewModel: DetailsViewModel {
        let viewModel = DetailsViewModel()
        viewModel.coordinatorDelegate = self
        return viewModel
    }
    
    // MARK: - Coordinator
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    override func start() {
        let viewController =  HomeViewController.instantiateFromStoryboard(storyboard)
        viewController.viewModel = homeViewModel
        rootViewController.setViewControllers([viewController], animated: false)
    }
    
    override func finish() {
        delegate?.didFinish(from: self)
    }
    
}
