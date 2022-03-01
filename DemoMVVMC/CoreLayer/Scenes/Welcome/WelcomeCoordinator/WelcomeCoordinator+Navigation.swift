//
//  WelcomeCoordinator+Navigation.swift
//  DemoMVVMC
//
//  Created by mac on 1/3/2022.
//

import UIKit

// MARK: - WelcomeCoordinator + Navigation
extension WelcomeCoordinator {
    func goToAdditionalInformation(from controller: UIViewController) {
        let viewController = ExtraInformationViewController.instantiateFromStoryboard(storyboard)
        viewController.viewModel = extraViewModel
        controller.present(viewController, animated: true, completion: nil)
    }
}
