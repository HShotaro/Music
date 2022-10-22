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
    let shareURL: URL?
    let imageURL: URL?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case externalUrls = "external_urls"
        case images
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try? container.decode(String.self, forKey: .type)
        let externalURLs = try? container.decode([String: String].self, forKey: .externalUrls)
        shareURL = URL(string: externalURLs?["spotify"] ?? "")
        let images = try? container.decode([APIImage].self, forKey: .images)
        imageURL = images?.first?.url
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try? container.encode(type, forKey: .type)
        let externalURLs = ["spotify": shareURL?.absoluteString ?? ""]
        try container.encode(externalURLs, forKey: .externalUrls)
        let apiImages = [APIImage(url: imageURL)]
        try container.encode(apiImages, forKey: .images)
    }
    
    init(id: String, name: String, type: String?, shareURL: URL?, imageURL: URL?) {
        self.id = id
        self.name = name
        self.type = type
        self.shareURL = shareURL
        self.imageURL = imageURL
    }
    
    static func mock(_ id: Int) -> ArtistModel {
        return ArtistModel(id: "\(id)", name: "Artist Name" + "\(id)", type: "Artist Type", shareURL: URL(string: "https://via.placeholder.com/200x200"), imageURL: URL(string: "https://via.placeholder.com/200x200"))
    }
    
    static func == (lhs: ArtistModel, rhs: ArtistModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
