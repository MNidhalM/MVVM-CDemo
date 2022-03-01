//
//  AppCoordinator+Navigation.swift
//  DemoMVVMC
//
//  Created by mac on 1/3/2022.
//

import Foundation

// MARK: - AppCoordinator + Navigation
extension AppCoordinator {
    func goToWelcomeFlow() {
        let welcomeCoordinator = WelcomeCoordinator(rootViewController: rootViewController)
        welcomeCoordinator.delegate = self
        addChildCoordinator(welcomeCoordinator)
        welcomeCoordinator.start()
    }
    
    func goToHomeFlow() {
        let homeCoordinator = HomeCoordinator(rootViewController: rootViewController)
        homeCoordinator.delegate = self
        addChildCoordinator(homeCoordinator)
        homeCoordinator.start()
    }
}

