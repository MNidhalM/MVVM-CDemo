//
//  IDView.swift
//  DemoMVVMC
//
//  Created by mac on 28/2/2022.
//

import UIKit

class IDView: NibLoadingView {
    private var viewModel: UserViewModel?
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
}

extension IDView {
    public func configureView(viewModel: UserViewModel) {
        self.viewModel = viewModel
    }
}
