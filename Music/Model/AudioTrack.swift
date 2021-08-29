//
//  AudioTrack.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import Foundation

struct AudioTrack: Codable, Equatable {
    var album: Album?
    let artists: [Artist]?
    let available_markets: [String]?
    let disc_number: Int?
    let duration_ms: Int?
    let explicit: Bool?
    let external_urls: [String: String]?
    let id: String
    let name: String
    let popularity: Int?
    let preview_url: String?
    
    static func == (lhs: AudioTrack, rhs: AudioTrack) -> Bool {
        return lhs.id == rhs.id
    }
}

struct AudioTrackModel : Hashable, Identifiable {
    let id: String
    let name: String
    let artist: ArtistModel
    let album: AlbumModel
    let previewURL: URL?
    
    init(rawModel: AudioTrack) {
        id = rawModel.id
        name = rawModel.name
        if let rawArtist = rawModel.artists?.first {
            artist = ArtistModel(rawModel: rawArtist)
        } else {
            artist = ArtistModel.mock(Int(id) ?? 0)
        }
        if let rawAlbum = rawModel.album {
            album = AlbumModel(rawModel: rawAlbum)
        } else {
            album = AlbumModel.mock(Int(id) ?? 0)
        }
        previewURL = URL(string: rawModel.preview_url ?? "")
    }
    
    init(
        id: String,
        name: String,
        artist: ArtistModel,
        album: AlbumModel,
        previewURL: URL?
    ) {
        self.id = id
        self.name = name
        self.artist = artist
        self.album = album
        self.previewURL = previewURL
    }
    
    static func mock(_ id: Int) -> AudioTrackModel {
        return AudioTrackModel(
                id: "\(id)",
                name: "AudioTrack Name" + "\(id)",
                artist: ArtistModel.mock(id),
                album: AlbumModel.mock(id),
                previewURL: URL(string: "https://via.placeholder.com/200x200")
        )
    }
    
    static func == (lhs: AudioTrackModel, rhs: AudioTrackModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


extension Array where Element == AudioTrackModel {
    func isSameOf(_ tracks: [AudioTrackModel]) -> Bool {
        let lhsIDs = self.compactMap { $0.id}.sorted { $0 < $1}
        let rhsIDs = tracks.map { $0.id }.sorted { $0 < $1}
        return lhsIDs == rhsIDs
    }
}
