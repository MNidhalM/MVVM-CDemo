//
//  SigninSignupCoordinator.swift
//  DemoMVVMC
//
//  Created by mac on 25/2/2022.
//

import UIKit


class WelcomeCoordinator: Coordinator {
  
    // MARK: - Properties
    let rootViewController: UINavigationController
    let storyboard = "Welcome"
    weak var delegate: WelcomeCoordinatorDelegate?

    // MARK: ViewModels
    lazy var welcomeViewModel: WelcomeViewModel! = {
        let viewModel = WelcomeViewModel(userViewModel: UserViewModel())
        viewModel.coordinatorDelegate = self
        return viewModel
    }()

    lazy var extraViewModel: ExtraViewModel! = {
        let viewModel = ExtraViewModel(userViewModel: UserViewModel())
        viewModel.coordinatorDelegate = self
        return viewModel
    }()

    // MARK: - Coordinator
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    override func start() {
        let viewController = WelcomeViewController.instantiateFromStoryboard(storyboard)
        viewController.modalPresentationStyle = .fullScreen
        viewController.viewModel = welcomeViewModel
        rootViewController.setViewControllers([viewController], animated: false)
    }

    override func finish() {
        delegate?.didFinish(from: self)
    }
    
}

