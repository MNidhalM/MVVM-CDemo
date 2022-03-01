//
//  SneakerTableViewCell.swift
//  DemoMVVMC
//
//  Created by mac on 28/2/2022.
//

import UIKit

class SneakerTableViewCell: UITableViewCell {

    @IBOutlet weak var sneakerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    
    public var viewModel: SneakerTableViewCellViewModel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(viewModel: SneakerTableViewCellViewModel) {
        self.viewModel = viewModel
        brandLabel.text = viewModel.brand
        nameLabel.text = viewModel.name
    }
}
