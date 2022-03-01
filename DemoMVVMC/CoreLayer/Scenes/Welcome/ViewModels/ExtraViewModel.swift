//
//  ExtraViewModel.swift
//  DemoMVVMC
//
//  Created by mac on 27/2/2022.
//

import UIKit

class ExtraViewModel {
    // MARK: - Properties
    let validAge = 1...100
    private var userViewModel: UserViewModel
    public weak var coordinatorDelegate : ExtraViewModelCoordinatorDelegate?
    @Published public var age: String?
    @Published public var gender: Gender?
    
    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
    }
}

// MARK: - Helpers
extension ExtraViewModel {
    public func checkValidData() -> Bool {
        guard let age = age,
              !age.isEmpty,
              validAge.contains(age.toInt()),
              gender != nil
        else {
            return false
        }
        return true
    }
}

// MARK: - UserActions
extension ExtraViewModel {
    func saveTapped(from controller: UIViewController) {
        coordinatorDelegate?.save(from: controller)
    }
}
