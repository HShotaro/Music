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
    private let artists: [ArtistModel]?
    var artist: ArtistModel {
        if let artist = artists?.first {
            return artist
        } else {
            return ArtistModel.mock(Int(id) ?? 0)
        }
    }
    let album: AlbumModel?
    let availableMarkets: [String]?
    private let discNumber: Int?
    private let durationMs: Int?
    private let explicit: Bool?
    private let popularity: Int?
    private let externalUrls: [String: String]?
    private let preview_url: String?
    var previewURL: URL? {
        return URL(string: preview_url ?? "")
    }
    
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
    
    static func mock(_ id: Int) -> AudioTrackModel {
        return AudioTrackModel(
            id: "\(id)",
            name: "AudioTrack Name" + "\(id)",
            artists: [ArtistModel.mock(id)],
            album: AlbumModel.mock(id),
            availableMarkets: nil,
            discNumber: nil,
            durationMs: nil,
            explicit: nil,
            popularity: nil,
            externalUrls: nil,
            preview_url: "https://via.placeholder.com/200x200"
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
            artists: [artist],
            album: album,
            availableMarkets: availableMarkets,
            discNumber: discNumber,
            durationMs: durationMs,
            explicit: explicit,
            popularity: popularity,
            externalUrls: externalUrls,
            preview_url: preview_url
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
