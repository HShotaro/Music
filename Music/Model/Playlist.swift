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
    private let images: [APIImage]?
    let name: String
    let owner: User?
    var creatorName: String {
        return owner?.displayName ?? ""
    }
    var imageURL: URL? {
        return URL(string: images?.first?.url ?? "")
    }
    
    private enum CodingKeys: String, CodingKey {
        case description
        case externalUrls = "external_urls"
        case id
        case images
        case name
        case owner
    }
    
    static func mock(_ id: Int) -> PlayListModel {
        PlayListModel(description: nil, externalUrls: nil, id: "\(id)", images: [APIImage(url: "https://via.placeholder.com/200x200")], name: "Playlist Name" + "\(id)", owner: User(displayName: "Creator Name", externalUrls: [:], id: ""))
    }
    
    static func == (lhs: PlayListModel, rhs: PlayListModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
