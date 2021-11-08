//
//  Artist.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import Foundation

struct ArtistModel: Codable, Hashable {
    let id: String
    let name: String
    let type: String?
    private let externalUrls: [String: String]?
    private let images: [APIImage]?
    var shareURL: URL? {
        return URL(string: externalUrls?["spotify"] ?? "")
    }
    var imageURL: URL? {
        return URL(string: images?.first?.url ?? "")
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case externalUrls = "external_urls"
        case images
    }
    
    static func mock(_ id: Int) -> ArtistModel {
        return ArtistModel(id: "\(id)", name: "Artist Name" + "\(id)", type: "Artist Type", externalUrls: ["spotify":"https://via.placeholder.com/200x200"], images: [APIImage(url: "https://via.placeholder.com/200x200")])
    }
    
    static func == (lhs: ArtistModel, rhs: ArtistModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
