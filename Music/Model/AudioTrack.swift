//
//  AudioTrack.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import Foundation

struct AudioTrackModel : Codable, Equatable, Hashable, Identifiable {
    let id: String
    let name: String
    let artist: ArtistModel
    let album: AlbumModel?
    let availableMarkets: [String]?
    private let discNumber: Int?
    private let durationMs: Int?
    private let explicit: Bool?
    private let popularity: Int?
    private let externalUrls: [String: String]?
    let previewURL: URL?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case album
        case artists
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case discNumber = "disc_number"
        case durationMs = "duration_ms"
        case explicit
        case popularity
        case preview_url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        album = try? container.decode(AlbumModel.self, forKey: .album)
        let artists = try? container.decode([ArtistModel].self, forKey: .artists)
        artist = artists?.first ?? ArtistModel.mock(Int(id) ?? 0)
        availableMarkets = try? container.decode([String].self, forKey: .availableMarkets)
        externalUrls = try? container.decode([String: String].self, forKey: .externalUrls)
        discNumber = try? container.decode(Int.self, forKey: .discNumber)
        durationMs = try? container.decode(Int.self, forKey: .durationMs)
        explicit = try? container.decode(Bool.self, forKey: .explicit)
        popularity = try? container.decode(Int.self, forKey: .popularity)
        let previewURLStr = try? container.decode(String.self, forKey: .preview_url)
        previewURL = URL(string: previewURLStr ?? "")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try? container.encode(album, forKey: .album)
        try container.encode([artist], forKey: .artists)
        try? container.encode(availableMarkets, forKey: .availableMarkets)
        try? container.encode(externalUrls, forKey: .externalUrls)
        try? container.encode(discNumber, forKey: .discNumber)
        try? container.encode(durationMs, forKey: .durationMs)
        try? container.encode(explicit, forKey: .explicit)
        try? container.encode(popularity, forKey: .popularity)
        try? container.encode(previewURL?.absoluteString ?? "", forKey: .preview_url)
    }
    
    init(
        id: String,
        name: String,
        artist: ArtistModel,
        album: AlbumModel?,
        availableMarkets: [String]?,
        discNumber: Int?,
        durationMs: Int?,
        explicit: Bool?,
        popularity: Int?,
        externalUrls: [String: String]?,
        previewURL: URL?
    ) {
        self.id = id
        self.name = name
        self.artist = artist
        self.album = album
        self.availableMarkets = availableMarkets
        self.discNumber = discNumber
        self.durationMs = durationMs
        self.explicit = explicit
        self.popularity = popularity
        self.externalUrls = externalUrls
        self.previewURL = previewURL
    }
    
    static func mock(_ id: Int) -> AudioTrackModel {
        return AudioTrackModel(
            id: "\(id)",
            name: "AudioTrack Name" + "\(id)",
            artist: ArtistModel.mock(id),
            album: AlbumModel.mock(id),
            availableMarkets: nil,
            discNumber: nil,
            durationMs: nil,
            explicit: nil,
            popularity: nil,
            externalUrls: nil,
            previewURL: nil
        )
    }
    
    static func == (lhs: AudioTrackModel, rhs: AudioTrackModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AudioTrackModel {
    func exchangeAlbum(album: AlbumModel) -> AudioTrackModel {
        
        
        return AudioTrackModel(
            id: id,
            name: name,
            artist: artist,
            album: album,
            availableMarkets: availableMarkets,
            discNumber: discNumber,
            durationMs: durationMs,
            explicit: explicit,
            popularity: popularity,
            externalUrls: externalUrls,
            previewURL: previewURL
        )
    }
}

extension Array where Element == AudioTrackModel {
    func isSameOf(_ tracks: [AudioTrackModel]) -> Bool {
        let lhsIDs = self.compactMap { $0.id}.sorted { $0 < $1}
        let rhsIDs = tracks.map { $0.id }.sorted { $0 < $1}
        return lhsIDs == rhsIDs
    }
}
