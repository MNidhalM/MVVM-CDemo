//
//  HomeCoordinator+Navigation.swift
//  DemoMVVMC
//
//  Created by mac on 1/3/2022.
//

import Foundation

// MARK: - Navigation
extension HomeCoordinator {
    func goToDetails() {
        let viewController = DetailsViewController.instantiateFromStoryboard(storyboard)
        viewController.viewModel = detailsViewModel
        rootViewController.pushViewController(viewController, animated: true)
        
    }
}
