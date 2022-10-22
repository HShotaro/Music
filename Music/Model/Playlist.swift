//
//  Playlist.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/25.
//

import Foundation

struct PlaylistResponse: Codable {
    let items: [PlayListModel]
}

struct PlayListModel: Codable, Hashable {
    private let description: String?
    private let externalUrls: [String: String]?
    let id: String
    let imageURL: URL?
    let name: String
    let creatorName: String

    
    private enum CodingKeys: String, CodingKey {
        case description
        case externalUrls = "external_urls"
        case id
        case images
        case name
        case owner
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try? container.decode(String.self, forKey: .description)
        externalUrls = try? container.decode([String: String].self, forKey: .externalUrls)
        id = try container.decode(String.self, forKey: .id)
        let apiImages = try? container.decode([APIImage].self, forKey: .images)
        imageURL = apiImages?.first?.url
        name = try container.decode(String.self, forKey: .name)
        let owner = try? container.decode(User.self, forKey: .owner)
        creatorName = owner?.displayName ?? ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(description, forKey: .description)
        try? container.encode(externalUrls, forKey: .externalUrls)
        try container.encode(id, forKey: .id)
        let apiImages = [APIImage(url: imageURL)]
        try container.encode(apiImages, forKey: .images)
        try container.encode(name, forKey: .name)
        let owner = User(displayName: creatorName, externalUrls: [:], id: "")
        try container.encode(owner, forKey: .owner)
      }
    
    init(id: String, name: String, creatorName: String, imageURL: URL?) {
        self.description = nil
        self.externalUrls = nil
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.creatorName = creatorName
    }
    
    static func mock(_ id: Int) -> PlayListModel {
        PlayListModel(id: "\(id)", name: "Playlist Name" + "\(id)", creatorName: "Creator Name", imageURL: URL(string: "https://via.placeholder.com/200x200"))
    }
    
    static func == (lhs: PlayListModel, rhs: PlayListModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
