//
//  AubumDetailsResponse.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/02.
//

import Foundation

struct AlbumDetailResponse: Codable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let tracks: TracksResponse
}

struct TracksResponse: Codable {
    let items: [AudioTrack]
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
        imageURL = URL(string: rawModel.images.first?.url ?? "")
        shareURL = URL(string: rawModel.external_urls["spotify"] ?? "")
        if let rawArtist = rawModel.artists.first {
            artist = ArtistModel(rawModel: rawArtist)
        } else {
            artist = ArtistModel.mock(Int(id) ?? 0)
        }
        tracks = rawModel.tracks.items.map { AudioTrackModel(rawModel: $0) }.filter{ $0.previewURL != nil }
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
