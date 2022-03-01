//
//  HomeCoordinator+Extension.swift
//  DemoMVVMC
//
//  Created by mac on 1/3/2022.
//

import Foundation


// MARK: - HomeViewModelCoordinatorDelegate
extension HomeCoordinator: HomeViewModelCoordinatorDelegate {
    func logout() {
        finish()
    }
    
    func showDetails() {
        
    }
}
