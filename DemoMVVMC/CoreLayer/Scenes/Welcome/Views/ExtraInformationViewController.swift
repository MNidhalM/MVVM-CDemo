//
//  ExtraInformationViewController.swift
//  DemoMVVMC
//
//  Created by mac on 27/2/2022.
//

import UIKit
import Combine

final class ExtraInformationViewController: UIViewController {
    
    // MARK: - Properties
    public var viewModel: ExtraViewModel!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Outlets
    @IBOutlet private (set) weak var saveButton: UIButton!
    @IBOutlet private (set) weak var genderLabel: UILabel!
    @IBOutlet private (set) weak var maleButton: UIButton!
    @IBOutlet private (set) weak var femaleButton: UIButton!
    @IBOutlet private (set) weak var ageTextField: UITextField!
    @IBOutlet private (set) weak var ageLabel: UILabel!
        
    @IBAction func saveTapped(_ sender: UIButton) {
        viewModel.saveTapped(from: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupUI()
        setupSubscribers()
        setupObservers()
    }
    
}

// MARK: - Init Helpers
private extension ExtraInformationViewController {
    func setupUI() {
        saveButton.addTarget(self, action: #selector(saveTapped(_:)), for: .touchUpInside)
        ageTextField.placeholder = "Age must be under 100"
        updateMaleButton(isSelected: false)
        updateFemaleButton(isSelected: false)
    }
    
    func setupSubscribers() {
        ageTextField.textPublisher.receive(on: RunLoop.main).sink { [weak self] value in
            guard let self = self else { return }
            self.viewModel.age = value
        }.store(in: &cancellables)

        maleButton.publisher(for: .touchUpInside).receive(on: RunLoop.main).sink { [weak self] value in
            guard let self = self else { return }
            self.viewModel.gender = .male
            self.updateMaleButton(isSelected: true)
            self.updateFemaleButton(isSelected: false)
        }.store(in: &cancellables)
        
        femaleButton.publisher(for: .touchUpInside).receive(on: RunLoop.main).sink { [weak self] value in
            guard let self = self else { return }
            self.viewModel.gender = .female
            self.updateMaleButton(isSelected: false)
            self.updateFemaleButton(isSelected: true)
        }.store(in: &cancellables)

    }

    func setupObservers() {
        viewModel.$age.receive(on: RunLoop.main).sink { [weak self] value in
            guard let self = self else { return }
            self.modeButton()
        }.store(in: &cancellables)

        viewModel.$gender.receive(on: RunLoop.main).sink { [weak self] value in
            guard let self = self else { return }
            self.modeButton()
        }.store(in: &cancellables)

    }
    func setupDelegates() {
        ageTextField.delegate = self
    }
}

// MARK: - Helpers
private extension ExtraInformationViewController {
    func updateMaleButton(isSelected: Bool) {
        maleButton.backgroundColor = isSelected ? UIColor.blueColor : UIColor.white
        maleButton.setTitleColor(isSelected ? UIColor.white : UIColor.blueColor, for: .normal)
    }
    
    func updateFemaleButton(isSelected: Bool) {
        femaleButton.backgroundColor = isSelected ? UIColor.pinkColor : UIColor.white
        femaleButton.setTitleColor(isSelected ? UIColor.white : UIColor.pinkColor, for: .normal)
    }

    func modeButton() {
        saveButton.backgroundColor = viewModel.checkValidData() ? UIColor.primaryColor : UIColor.white
        saveButton.setTitleColor((viewModel.checkValidData() ? UIColor.white : UIColor.primaryColor), for: .normal)
        saveButton.isEnabled = viewModel.checkValidData()
    }
}

// MARK: - UITextFieldDelegate
extension ExtraInformationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
