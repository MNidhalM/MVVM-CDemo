//
//  SigninViewController.swift
//  DemoMVVMC
//
//  Created by mac on 25/2/2022.
//

import UIKit
import Combine

final class WelcomeViewController: UIViewController {

    // MARK: - Properties
    public var viewModel: WelcomeViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Outlets
    @IBOutlet private (set) weak var continueButton: UIButton!
    @IBOutlet private (set) weak var addInformationButton: UIButton!
    @IBOutlet private (set) weak var titleLabel: UILabel!
    @IBOutlet private (set) weak var lastNameTextField: UITextField!
    @IBOutlet private (set) weak var firstNameTextField: UITextField!
    @IBOutlet private (set) weak var lastNameLabel: UILabel!
    @IBOutlet private (set) weak var firstNameLabel: UILabel!
    
    @IBAction func continueTapped(_ sender: UIButton) {
        viewModel.continueTapped()
    }
    
    @IBAction func additionalTapped(_ sender: UIButton) {
        viewModel.additionalTapped(from: self)
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupUI()
        setupSubscribers()
        setupObservers()
    }
}

// MARK: - Init Helpers
private extension WelcomeViewController {
    func setupUI() {
        continueButton.addTarget(self, action: #selector(continueTapped(_:)), for: .touchUpInside)
        addInformationButton.addTarget(self, action: #selector(additionalTapped(_:)), for: .touchUpInside)
        
        firstNameTextField.tag = 10
        lastNameTextField.tag = 20
        
        firstNameTextField.placeholder = "enter your firstName"
        lastNameTextField.placeholder = "enter your lastName"

    }
    
    func setupSubscribers() {
        firstNameTextField.textPublisher.receive(on: RunLoop.main).sink { [weak self] value in
            guard let self = self else { return }
            self.viewModel.firstName = value
        }.store(in: &cancellables)
       
        
        lastNameTextField.textPublisher.receive(on: RunLoop.main).sink { [weak self] value in
            guard let self = self else { return }
            self.viewModel.lastName = value
        }.store(in: &cancellables)
    }
    
    func setupObservers() {
        viewModel.$firstName.receive(on: RunLoop.main).sink { [weak self] _ in
            guard let self = self else { return }
            self.modeButton()
        }.store(in: &cancellables)

        viewModel.$lastName.receive(on: RunLoop.main).sink { [weak self] _ in
            guard let self = self else { return }
            self.modeButton()
        }.store(in: &cancellables)
    }
    
    func modeButton() {
        continueButton.backgroundColor = viewModel.checkValidData() ? UIColor.primaryColor : UIColor.white
        continueButton.setTitleColor((viewModel.checkValidData() ? UIColor.white : UIColor.primaryColor), for: .normal)
        continueButton.isEnabled = viewModel.checkValidData()
    }

    func setupDelegates() {
        lastNameTextField.delegate = self
        firstNameTextField.delegate = self
    }
}

// MARK: - UITextFieldDelegate
extension WelcomeViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 10 {
            lastNameTextField.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
}
