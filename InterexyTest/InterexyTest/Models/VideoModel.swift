//
//  VideoModel.swift
//  InterexyTest
//
//  Created by Алексей Смоляк on 15.01.23.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - VideoModel
struct VideoModel: Codable {
    let id: Int?
    let results: [Video]?
}

// MARK: - Video
struct Video: Codable {
    let iso639_1: ISO639_1?
    let iso3166_1: ISO3166_1?
    let name, key: String?
    let site: String?
    let size: Int?
    let type: String?
    let official: Bool?
    let publishedAt, id: String?

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
}

enum ISO3166_1: String, Codable {
    case us = "US"
}

enum ISO639_1: String, Codable {
    case en = "en"
}
