//
//  SneakerResponse.swift
//  Running
//
//  Created by mac on 24/1/2022.
//  Created by Nidhal on 27/11/2021.
//

import Foundation

// MARK: - AllSneakerResponse
struct AllSneakerResponse: Codable {
    let count: Int
    let results: [SneakerResponse]
}

// MARK: - SneakerResponse
struct SneakerResponse: Codable {
    let id: String
    let brand: String
    let colorway: String
    let gender: String
    let name, releaseDate: String
    let retailPrice: Int
    let shoe: String
    let styleID, title: String
    let year: Int
    let media: Media

    enum CodingKeys: String, CodingKey {
        case id, brand, colorway, gender, name, releaseDate, retailPrice, shoe
        case styleID = "styleId"
        case title, year, media
    }
}


// MARK: - Media
struct Media: Codable {
    let imageURL, smallImageURL, thumbURL: String?

    enum CodingKeys: String, CodingKey {
        case imageURL = "imageUrl"
        case smallImageURL = "smallImageUrl"
        case thumbURL = "thumbUrl"
    }
}
