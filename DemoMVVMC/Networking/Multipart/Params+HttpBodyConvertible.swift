//
//  Params+HttpBodyConvertible.swift
//  bazaryios
//
//  Created by Feker Hassine on 2020-12-17.
//

import Foundation

public typealias Params = [String: CustomStringConvertible]

extension Params: HttpBodyConvertible {
    public func buildHttpBodyPart(boundary: String) -> Data {
        let httpBody = NSMutableData()
        forEach { (name, value) in
            httpBody.appendString("--\(boundary)\r\n")
            httpBody.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
            httpBody.appendString(value.description)
            httpBody.appendString("\r\n")
        }
        return httpBody as Data
    }
}
