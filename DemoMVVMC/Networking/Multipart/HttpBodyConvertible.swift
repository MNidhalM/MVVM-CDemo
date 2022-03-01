//
//  HttpBodyConvertible.swift
//  bazaryios
//
//  Created by Feker Hassine on 2020-12-17.
//

import Foundation

public protocol HttpBodyConvertible {
    func buildHttpBodyPart(boundary: String) -> Data
}
