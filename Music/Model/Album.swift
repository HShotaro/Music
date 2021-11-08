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
    private let images: [APIImage]?
    var imageURL: URL? {
        return URL(string: images?.first?.url ?? "")
    }
    let name: String
    private let release_date: String?
    var releaseDate: String {
        return String.formattedDate(string: release_date ?? "")
    }
    let totalTracks: Int?
    private let artists: [ArtistModel]?
    var artist: ArtistModel {
        if let artist = artists?.first {
            return artist
        } else {
            return ArtistModel.mock(Int(id) ?? 0)
        }
    }
    
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
    
    static func mock(_ id: Int) -> AlbumModel {
        return AlbumModel(
            type: "Album Type", availableMarkets: nil, id: "\(id)", images: [APIImage(url: "https://via.placeholder.com/200x200")], name: "Album Name" + "\(id)", release_date: "2021/8/29", totalTracks: id + 3, artists: [ArtistModel.mock(id)])
    }
    
    static func == (lhs: AlbumModel, rhs: AlbumModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
