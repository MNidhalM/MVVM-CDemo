//
//  SigninViewModel.swift
//  DemoMVVMC
//
//  Created by mac on 25/2/2022.
//

import UIKit


class WelcomeViewModel {
    // MARK: - Properties
    private var userViewModel: UserViewModel
    weak var coordinatorDelegate : WelcomeViewModelCoordinatorDelegate?
    @Published public var firstName: String?
    @Published public var lastName: String?
    
    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
    }
}

// MARK: - Helpers
extension WelcomeViewModel {
    func checkValidData() -> Bool {
        guard let firstName = firstName,
           !firstName.isEmpty,
           let lastName = lastName,
           !lastName.isEmpty else {
            return false
        }
        return true
    }
}

// MARK: - UserActions
extension WelcomeViewModel {
    func continueTapped() {
        coordinatorDelegate?.next()
    }
    
    func additionalTapped(from controller: UIViewController) {
        coordinatorDelegate?.add(from: controller)
    }
}
