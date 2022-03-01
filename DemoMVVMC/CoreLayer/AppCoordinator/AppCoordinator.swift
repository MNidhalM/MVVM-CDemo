//
//  AppCoordinator.swift
//  DemoMVVMC
//
//  Created by mac on 25/2/2022.
//

import UIKit

// MARK: - AppCoordinator
class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    let window: UIWindow?
    
    lazy var rootViewController: UINavigationController = {
        return UINavigationController()
    }()
    
    // MARK: - Coordinator
    init(window: UIWindow?) {
        self.window = window
    }
    
    override func start() {
        guard let window = window else {
            return
        }
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        goToWelcomeFlow()
    }
    
    override func finish() {
    }
    
}
