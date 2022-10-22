//
//  Album.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import Foundation

struct AlbumsResponse: Codable {
    let items: [AlbumModel]
}

struct AlbumModel : Codable, Hashable {
    let type: String?
    private let availableMarkets: [String]?
    let id: String
    let imageURL: URL?
    let name: String
    let releaseDate: String
    let totalTracks: Int?
    let artist: ArtistModel
    
    private enum CodingKeys: String, CodingKey {
        case type = "album_type"
        case availableMarkets = "available_markets"
        case id
        case images
        case name
        case release_date = "release_date"
        case totalTracks = "total_tracks"
        case artists
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try? container.decode(String.self, forKey: .type)
        availableMarkets = try? container.decode([String].self, forKey: .availableMarkets)
        id = try container.decode(String.self, forKey: .id)
        let images = try? container.decode([APIImage].self, forKey: .images)
        imageURL = images?.first?.url
        name = try container.decode(String.self, forKey: .name)
        let release_date = try? container.decode(String.self, forKey: .release_date)
        releaseDate = String.formattedDate(string: release_date ?? "")
        totalTracks = try? container.decode(Int.self, forKey: .totalTracks)
        let artists = try? container.decode([ArtistModel].self, forKey: .artists)
        artist = artists?.first ?? ArtistModel.mock(Int(id) ?? 0)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(type, forKey: .type)
        try? container.encode(availableMarkets, forKey: .availableMarkets)
        try container.encode(id, forKey: .id)
        let apiImages = [APIImage(url: imageURL)]
        try container.encode(apiImages, forKey: .images)
        try container.encode(name, forKey: .name)
        try container.encode(releaseDate, forKey: .release_date)
        try? container.encode(totalTracks, forKey: .totalTracks)
        try container.encode([artist], forKey: .artists)
    }
    
    init(
        type: String?,
        availableMarkets: [String]?,
        id: String,
        imageURL: URL?,
        name: String,
        releaseDate: String,
        totalTracks: Int?,
        artist: ArtistModel
    ) {
        self.type = type
        self.availableMarkets = availableMarkets
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.releaseDate = releaseDate
        self.totalTracks = totalTracks
        self.artist = artist
    }
    
    static func mock(_ id: Int) -> AlbumModel {
        return AlbumModel(type: "Album Type", availableMarkets: nil, id: "\(id)", imageURL: URL(string: "https://via.placeholder.com/200x200"), name: "Album Name" + "\(id)", releaseDate: "2021/8/29", totalTracks: id + 3, artist: ArtistModel.mock(id))
    }
    
    static func == (lhs: AlbumModel, rhs: AlbumModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
