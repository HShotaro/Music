//
//  Album.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import Foundation

struct AlbumsResponse: Codable {
    let items: [Album]
}

struct Album: Codable {
    let album_type: String?
    let available_markets: [String]?
    let id: String
    var images: [APIImage]?
    let name: String
    let release_date: String?
    let total_tracks: Int?
    let artists: [Artist]?
}

struct AlbumModel : Hashable {
    let id: String
    let name: String
    let type: String
    let releaseDate: String
    let imageURL: URL?
    let totalTracks: Int
    let artist: ArtistModel
    
    init(rawModel: Album) {
        id = rawModel.id
        name = rawModel.name
        type = rawModel.album_type ?? ""
        releaseDate = String.formattedDate(string: rawModel.release_date ?? "")
        imageURL = URL(string: rawModel.images?.first?.url ?? "")
        totalTracks = rawModel.total_tracks ?? 0
        if let rawArtist = rawModel.artists?.first {
            artist = ArtistModel(rawModel: rawArtist)
        } else {
            artist = ArtistModel.mock(Int(id) ?? 0)
        }
    }
    
    init(
        id: String,
        name: String,
        type: String,
        releaseDate: String,
        imageURL: URL?,
        totalTracks: Int,
        artist: ArtistModel
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.releaseDate = releaseDate
        self.imageURL = imageURL
        self.totalTracks = totalTracks
        self.artist = artist
    }
    
    static func mock(_ id: Int) -> AlbumModel {
        return AlbumModel(
                id: "\(id)",
                name: "Album Name" + "\(id)",
                type: "Album Type",
                releaseDate: "2021/8/29",
                imageURL: URL(string: "https://via.placeholder.com/200x200"),
                totalTracks: id + 3,
            artist: ArtistModel.mock(id)
        )
    }
    
    static func == (lhs: AlbumModel, rhs: AlbumModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
