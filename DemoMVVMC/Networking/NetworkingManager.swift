//
//  NetworkingManager.swift
//  SwiftfulCryptoMNM
//
//  Created by Nidhal on 27/11/2021.
//

import Foundation
import Combine

class NetworkingManager {
        
    static func publisher<T: Decodable>(
        withLogs logsEnabled: Bool = false,
        withErrorMessage: Bool = true,
        for urlString: String,
        responseType: T.Type = T.self,
        decoder: JSONDecoder = .init(),
        encoding: HttpEncoding = .JSONEncoding,
        method: HttpMethod = .post,
        params: Params? = nil,
        multipartData: [MultipartData]? = nil,
        headers: [String: String]? = nil,
        withToken: Bool = false,
        withBaseUrl: Bool = true
    ) -> AnyPublisher<T, Error> {
        guard
            let urlRequest = buildURLRequest(urlString: urlString, method: method, encoding: encoding, params: params, multipartData: multipartData, headers: headers)
        else
        {
            return Fail(error: NetworkingError.unableToParseRequest as Error)
                .eraseToAnyPublisher()
        }
        
        let url = URL(string: urlString)!
        print("start call: \(url)")
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ try handleUrlResponse(output: $0, url: url) })
//            .retry(3)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    static func handleUrlResponse(output: URLSession.DataTaskPublisher.Output,url: URL) throws -> Data {
        let response = output.response
        let data = output.data
        print("finish call")

        if let response = response as? HTTPURLResponse {
            print(response.statusCode)
        }
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
                  
                  throw NetworkingError.badUrlResponse(url: url)
              }
        return data
    }
}

extension NetworkingManager {
    static func buildURLRequest(urlString: String, method: HttpMethod, encoding: HttpEncoding, params: Params? = nil, multipartData: [MultipartData]? = nil, headers: [String: String]? = nil) -> URLRequest? {
        var urlString = urlString
        if method == .get {
            urlString = getURLWithParams(urlString: urlString, params: params)
        }
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        if method != .get && multipartData == nil {
            switch encoding {
            case .URLEncoding:
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            case .JSONEncoding:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        
        request.httpMethod = method.rawValue
        if let headers = headers
        {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if method != .get && multipartData == nil {
            switch encoding {
            case .URLEncoding:
                if let params = params
                {
                    request.httpBody = percentEncodedString(params: params).data(using: .utf8)
                }
            case .JSONEncoding:
                if let params = params
                {
                    let jsonData = try? JSONSerialization.data(withJSONObject: params)
                    request.httpBody = jsonData
                }
            }
        }
                
        // Multipart
        if let multiparts = multipartData {
            // Construct a unique boundary to separate values
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = buildMultipartHttpBody(params: params, multiparts: multiparts, boundary: boundary)
        }
        
        return request
    }
    
    static func getURLWithParams(urlString:String, params: [String: Any]?) -> String {
        guard let url = URL(string: urlString), let params = params else {
            return urlString
        }
        
        if var urlComponents = URLComponents(url: url,resolvingAgainstBaseURL: false) {
            var queryItems = urlComponents.queryItems ?? [URLQueryItem]()
            params.forEach { param in
                // arrayParam[] syntax
                if let array = param.value as? [CustomStringConvertible] {
                    array.forEach {
                        queryItems.append(URLQueryItem(name: "\(param.key)[]", value: "\($0)"))
                    }
                }
                queryItems.append(URLQueryItem(name: param.key, value: "\(param.value)"))
            }
            urlComponents.queryItems = queryItems
            return urlComponents.url?.absoluteString ?? urlString
        }
        return urlString
    }
    
    static func buildMultipartHttpBody(params: Params? = nil, multiparts: [MultipartData], boundary: String) -> Data {
        // Combine all multiparts together
        var allMultiparts: [HttpBodyConvertible] = []
        if let params = params
        {
            allMultiparts = [params] + multiparts
        }
        else
        {
            allMultiparts = multiparts
        }
        let boundaryEnding = "--\(boundary)--".data(using: .utf8)!
        
        // Convert multiparts to boundary-seperated Data and combine them
        return allMultiparts
            .map { (multipart: HttpBodyConvertible) -> Data in
                return multipart.buildHttpBodyPart(boundary: boundary)
            }
            .reduce(Data.init(), +)
        + boundaryEnding
    }
    
    static func percentEncodedString(params: [String: Any]) -> String {
        return params.map { key, value in
            let escapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            if let array = value as? [CustomStringConvertible] {
                return array.map { entry in
                    let escapedValue = "\(entry)"
                        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    return "\(key)[]=\(escapedValue)" }.joined(separator: "&"
                    )
            } else {
                let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                return "\(escapedKey)=\(escapedValue)"
            }
        }
        .joined(separator: "&")
    }
    
}
