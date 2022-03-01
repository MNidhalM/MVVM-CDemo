//
//  SneakerTableViewCellViewModel.swift
//  DemoMVVMC
//
//  Created by mac on 1/3/2022.
//

import Foundation

class SneakerTableViewCellViewModel {
    let name: String
    let brand: String
    let image: String?
    init(sneaker: Sneaker) {
        name = sneaker.name
        brand = sneaker.brand
        image = sneaker.image
    }
}
