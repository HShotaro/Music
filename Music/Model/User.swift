//
//  User.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/25.
//

import Foundation

struct User: Codable {
    let displayName: String
    let externalUrls: [String: String]
    let id: String
    
    private enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case externalUrls = "external_urls"
        case id
    }
}


struct UserProfile: Codable {
    let country: String;
    let displayName: String
    let email: String
    let explicitContent: [String: Bool]
    let externalUrls: [String: String]
    let id: String
    let product: String
    let images: [APIImage]
    
    private enum CodingKeys: String, CodingKey {
        case country
        case displayName = "display_name"
        case email
        case explicitContent = "explicit_content"
        case externalUrls = "external_urls"
        case id
        case product
        case images
    }
}
