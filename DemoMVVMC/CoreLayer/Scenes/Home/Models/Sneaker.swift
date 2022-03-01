//
//  Sneaker.swift
//  DemoMVVMC
//
//  Created by mac on 27/2/2022.
//

import Foundation

// MARK: - Sneaker
struct Sneaker: Hashable {
    internal init(id: String, brand: String, name: String, shoe: String, image: String?, isEmpty: Bool = false) {
        self.id = id
        self.brand = brand
        self.name = name
        self.shoe = shoe
        self.image = image
        self.isEmpty = isEmpty
    }
    
    var id: String
    var brand: String
    let name : String
    var shoe: String
    let image: String?
    // local proprieties
    var isEmpty: Bool = false
    
    init() {
        id = ""
        brand = ""
        name = ""
        shoe = ""
        image = nil
        isEmpty = true
    }
    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Sneaker, rhs: Sneaker) -> Bool {
        return lhs.id == rhs.id
    }
    
    mutating func updateID(_ newID: String) {
        self.id = newID
    }
}

extension Sneaker {
    func log() {
        print("Sneaker: id \(id)")
        print("Sneaker: brand \(brand)")
        print("Sneaker: name \(name)")
        print("Sneaker: shoe \(shoe)")
        print("Sneaker: image \(image ?? "n/a")")
        print("Sneaker: isEmpty \(isEmpty)")
    }
}
