//
//  Artist.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String?
    let external_urls: [String: String]?
    let images: [APIImage]?
}

struct ArtistModel : Hashable {
    let id: String
    let name: String
    let type: String
    let shareURL: URL?
    let imageURL: URL?
    
    init(rawModel: Artist) {
        id = rawModel.id
        name = rawModel.name
        type = rawModel.type ?? ""
        shareURL = URL(string: rawModel.external_urls?["spotify"] ?? "")
        imageURL = URL(string: rawModel.images?.first?.url ?? "")
    }
    
    init(id: String, name: String, type: String, shareURL: URL?, imageURL: URL?) {
        self.id = id
        self.name = name
        self.type = type
        self.shareURL = shareURL
        self.imageURL = imageURL
    }
    
    static func mock(_ id: Int) -> ArtistModel {
        return ArtistModel(
            id: "\(id)",
            name: "Artist Name" + "\(id)",
            type: "Artist Type",
            shareURL: URL(string: "https://via.placeholder.com/200x200"),
            imageURL: URL(string: "https://via.placeholder.com/200x200")
        )
    }
    
    static func == (lhs: ArtistModel, rhs: ArtistModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
