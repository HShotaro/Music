//
//  PlaylistDetailsResponse.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import Foundation

struct PlaylistDetailsResponse: Codable {
    let description: String
    let externalUrls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let tracks: PlayListTracksResponse
    
    private enum CodingKeys: String, CodingKey {
        case description
        case externalUrls = "external_urls"
        case id
        case images
        case name
        case tracks
    }
}

struct PlayListTracksResponse: Codable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
    let track: AudioTrackModel
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
        imageURL = rawModel.images.first?.url
        description = rawModel.description
        shareURL = URL(string: rawModel.externalUrls["spotify"] ?? "")
        let rawTracks = rawModel.tracks.items.compactMap { item -> AudioTrackModel? in
            if item.track.previewURL != nil {
                return item.track
            } else {
                return nil
            }
        }
        var set = Set<AudioTrackModel>()
        // set.insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element)
        // newMemberがsetに既に入っている場合はinsertedがfalse、まだ入っていない場合はinsertedにtrueが返される。これによって、tracksの重複がない配列を取得できる。
        tracks = rawTracks.filter { set.insert($0).inserted }
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
