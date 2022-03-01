//
//  NetworkHelper.swift
//  Running
//
//  Created by mac on 24/1/2022.
//  Copyright © 2022 Zhortech. All rights reserved.
//

import Foundation

struct APIError: Decodable, Error {
    var message: String?
    var success: Bool
}

struct NetworkResponse<Wrapped: Decodable>: Decodable {
    var message: String?
    var success: Bool
    var data: Wrapped
}

enum HttpEncoding: String {
    case JSONEncoding
    case URLEncoding
}

enum HttpMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

enum NetworkingError: LocalizedError {
    case badUrlResponse(url: URL)
    case unknown
    case unableToParseRequest
    
    var errorDescription: String? {
        switch self {
        case .badUrlResponse(let url):
            return "[😡]bad response from URL:\(url)"
        case .unknown:
            return "[🤯]unknown error occured"
        case .unableToParseRequest:
            return "unableToParseRequest"
        }
    }
}
