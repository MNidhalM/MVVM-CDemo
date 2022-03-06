//
//  SneakerTableViewCell.swift
//  DemoMVVMC
//
//  Created by mac on 28/2/2022.
//

import UIKit

final class SneakerTableViewCell: UITableViewCell {

    @IBOutlet weak var sneakerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    
    public var viewModel: SneakerTableViewCellViewModel! {
        didSet {
            configure()
        }
    }
    
    private func configure() {
        brandLabel.text = viewModel.brand
        nameLabel.text = viewModel.name
    }
}
