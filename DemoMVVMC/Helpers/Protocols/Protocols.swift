//
//  Protocols.swift
//  DemoMVVMC
//
//  Created by mac on 1/3/2022.
//

import UIKit
import Combine

// MARK: - WelcomeViewModelCoordinatorDelegate
protocol WelcomeViewModelCoordinatorDelegate: AnyObject {
    func next()
    func add(from controller: UIViewController)
}

// MARK: - ExtraViewModelCoordinatorDelegate
protocol ExtraViewModelCoordinatorDelegate: AnyObject {
    func save(from controller: UIViewController)
}

// MARK: - WelcomeCoordinatorDelegate
protocol WelcomeCoordinatorDelegate: AnyObject {
    func didFinish(from coordinator: WelcomeCoordinator)
}

// MARK: - HomeViewModelCoordinatorDelegate
protocol HomeViewModelCoordinatorDelegate: AnyObject {
    func logout()
    func showDetails()
}

// MARK: - SneakerStore
protocol SneakerStore {
    func fetchWithPagination(page: Int) -> AnyPublisher<(sneakers: [Sneaker], count: Int), Error>
}

// MARK: - HomeCoordinatorDelegate
protocol HomeCoordinatorDelegate: AnyObject {
    func didFinish(from coordinator: HomeCoordinator)
}
