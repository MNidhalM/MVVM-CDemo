//
//  WelcomeCoordinator+Extensions.swift
//  DemoMVVMC
//
//  Created by mac on 28/2/2022.
//

import UIKit

// MARK: - WelcomeViewModelCoordinatorDelegate
extension WelcomeCoordinator: WelcomeViewModelCoordinatorDelegate {
    func next() {
        finish()
    }
    
    func add(from controller: UIViewController) {
        goToAdditionalInformation(from: controller)
    }
}

// MARK: - ExtraViewModelCoordinatorDelegate
extension WelcomeCoordinator: ExtraViewModelCoordinatorDelegate {
    func save(from controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}


