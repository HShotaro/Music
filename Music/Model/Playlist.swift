//
//  Playlist.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/25.
//

import Foundation

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

struct Playlist: Codable {
    let description: String?
    let external_urls: [String: String]?
    let id: String
    let images: [APIImage]?
    let name: String
    let owner: User?
}

struct PlayListModel: Hashable {
    let id: String
    let name: String
    let creatorName: String
    let imageURL: URL?
    
    init(rawModel: Playlist) {
        id = rawModel.id
        name = rawModel.name
        creatorName = rawModel.owner?.display_name ?? ""
        imageURL = URL(string: rawModel.images?.first?.url ?? "")
    }
    
    init(id: String, name: String, creatorName: String, imageURL: URL?) {
        self.id = id
        self.name = name
        self.creatorName = creatorName
        self.imageURL = imageURL
    }
    
    static func mock(_ id: Int) -> PlayListModel {
        return PlayListModel(
            id: "\(id)",
            name: "Playlist Name" + "\(id)",
            creatorName: "Creator Name",
            imageURL: URL(string: "https://via.placeholder.com/200x200")
        )
    }
    
    static func == (lhs: PlayListModel, rhs: PlayListModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
