//
//  AppCordinator+Extensions.swift
//  DemoMVVMC
//
//  Created by mac on 1/3/2022.
//

import Foundation

// MARK: - WelcomeCoordinatorDelegate
extension AppCoordinator:  WelcomeCoordinatorDelegate {
    func didFinish(from coordinator: WelcomeCoordinator) {
        rootViewController.popToRootViewController(animated: false)
        removeChildCoordinator(coordinator)
        goToHomeFlow()
    }
}

// MARK: - HomeCoordinatorDelegate
extension AppCoordinator:  HomeCoordinatorDelegate {
    func didFinish(from coordinator: HomeCoordinator) {
        rootViewController.popToRootViewController(animated: false)
        removeChildCoordinator(coordinator)
        goToWelcomeFlow()
    }
}
