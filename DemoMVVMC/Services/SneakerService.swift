//
//  SneakerService.swift
//  DemoMVVMC
//
//  Created by mac on 27/2/2022.
//

import Foundation
import Combine

struct SneakersConfiguration {
    static let sneakersURL = "https://v1-sneakers.p.rapidapi.com/v1/sneakers"
    static let apiHost = "v1-sneakers.p.rapidapi.com"
    static let limit = "50"
    static let apiKey = AppSettings.shared.sneakerApiKey
}

class SneakerService: SneakerStore {
    // MARK: - FETCH ALL Sneakers
    func fetchWithPagination(page: Int) -> AnyPublisher<(sneakers: [Sneaker], count: Int), Error>
    {
        let parameters = createParams(page: page)
        let headers = createHeaders()
        return NetworkingManager.publisher(
            for: SneakersConfiguration.sneakersURL,
               responseType: AllSneakerResponse.self,
               method: .get,
               params: parameters,
               headers: headers
        )
            .map(mapToSneakers)
            .eraseToAnyPublisher()
    }
}

extension SneakerService {
    private func createHeaders() ->  [String: String] {
        return [
            "x-rapidapi-host": SneakersConfiguration.apiHost,
            "x-rapidapi-key" : SneakersConfiguration.apiKey
        ]
    }
    
    private func createParams(page: Int) ->  Params {
        var params: [String: String] = [:]
        params.updateValue(SneakersConfiguration.limit, forKey: "limit")
        params.updateValue("\(page)", forKey: "page")
        return params
    }
    
    private func mapToSneakers(output: AllSneakerResponse) -> (sneakers: [Sneaker], count: Int) {
        let count = output.count
        let results = output.results
        let array = results.compactMap {Sneaker(id: $0.id, brand:$0.brand, name:$0.name, shoe:$0.shoe, image:$0.media.thumbURL)}
        return (array,count)
    }
    
}
