//
//  AubumDetailsResponse.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/02.
//

import Foundation

struct AlbumDetailResponse: Codable {
    let albumType: String
    let artists: [ArtistModel]
    let availableMarkets: [String]
    let externalUrls: [String: String]
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let tracks: TracksResponse
    
    private enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case id
        case images
        case label
        case name
        case tracks
    }
}

struct TracksResponse: Codable {
    let items: [AudioTrackModel]
}

struct AlbumDetailModel : Hashable, Equatable {
    let id: String
    let name: String
    let imageURL: URL?
    let shareURL: URL?
    let artist: ArtistModel
    let tracks: [AudioTrackModel]
    
    init(rawModel: AlbumDetailResponse) {
        id = rawModel.id
        name = rawModel.name
        imageURL = rawModel.images.first?.url
        shareURL = URL(string: rawModel.externalUrls["spotify"] ?? "")
        if let artist = rawModel.artists.first {
            self.artist = artist
        } else {
            artist = ArtistModel.mock(Int(id) ?? 0)
        }
        tracks = rawModel.tracks.items.filter{ $0.previewURL != nil }
    }
    
    init(
        id: String,
        name: String,
        imageURL: URL?,
        shareURL: URL?,
        artist: ArtistModel,
        tracks: [AudioTrackModel]
    ) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.artist = artist
        self.shareURL = shareURL
        self.tracks = tracks
    }
    
    static func mock(_ id: Int, hasTrack: Bool = true) -> AlbumDetailModel {
        return AlbumDetailModel(
            id: "\(id)",
            name: "Playlist Name" + "\(id)",
            imageURL: URL(string: "https://via.placeholder.com/200x200"),
            shareURL: URL(string: "https://via.placeholder.com/200x200"),
            artist: ArtistModel.mock(id),
            tracks: hasTrack ? [AudioTrackModel.mock(id), AudioTrackModel.mock(id + 1)] : []
        )
    }
    
    static func == (lhs: AlbumDetailModel, rhs: AlbumDetailModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AlbumDetailModel {
    func exchangeAlbum(album: AlbumModel) -> AlbumDetailModel {
        return AlbumDetailModel(
            id: self.id,
            name: self.name,
            imageURL: self.imageURL,
            shareURL: self.shareURL,
            artist: self.artist,
            tracks: self.tracks.map { $0.exchangeAlbum(album: album) }
        )
    }
}
