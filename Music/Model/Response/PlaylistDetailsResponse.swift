//
//  PlaylistDetailsResponse.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import Foundation

struct PlaylistDetailsResponse: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let tracks: PlayListTracksResponse
}

struct PlayListTracksResponse: Codable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
    let track: AudioTrack
}

struct PlaylistDetailModel : Hashable, Equatable {
    let id: String
    let name: String
    let imageURL: URL?
    let description: String
    let shareURL: URL?
    let tracks: [AudioTrackModel]
    
    init(rawModel: PlaylistDetailsResponse) {
        id = rawModel.id
        name = rawModel.name
        imageURL = URL(string: rawModel.images.first?.url ?? "")
        description = rawModel.description
        shareURL = URL(string: rawModel.external_urls["spotify"] ?? "")
        tracks = rawModel.tracks.items.map { AudioTrackModel(rawModel: $0.track) }.filter{ $0.previewURL != nil }
    }
    
    init(
        id: String,
        name: String,
        imageURL: URL?,
        description: String,
        shareURL: URL?,
        tracks: [AudioTrackModel]
    ) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.description = description
        self.shareURL = shareURL
        self.tracks = tracks
    }
    
    static func mock(_ id: Int, hasTrack: Bool = true) -> PlaylistDetailModel {
        return PlaylistDetailModel(
            id: "\(id)",
            name: "Playlist Name" + "\(id)",
            imageURL: URL(string: "https://via.placeholder.com/200x200"),
            description: "Playlist Description",
            shareURL: URL(string: "https://via.placeholder.com/200x200"),
            tracks: hasTrack ? [AudioTrackModel.mock(id), AudioTrackModel.mock(id + 1)] : []
        )
    }
    
    static func == (lhs: PlaylistDetailModel, rhs: PlaylistDetailModel) -> Bool {
        return lhs.id == rhs.id && lhs.tracks == lhs.tracks
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension PlaylistDetailModel {
    func removeTrack(id trackID: String) -> PlaylistDetailModel {
        let tracks = self.tracks.filter { $0.id != trackID }
        return PlaylistDetailModel(id: self.id, name: self.name, imageURL: self.imageURL, description: self.description, shareURL: self.shareURL, tracks: tracks)
    }
}
