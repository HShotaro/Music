//
//  ArtistTopTracksDataResponse.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import Foundation

struct ArtistTopTracksDataResponse: Codable {
    let tracks: [AudioTrack]
}

struct ArtistDetailModel : Equatable {
    let tracks: [AudioTrackModel]
    
    init(rawModel: ArtistTopTracksDataResponse) {
        tracks = rawModel.tracks.map { AudioTrackModel(rawModel: $0) }.filter{ $0.previewURL != nil }
    }
    
    init(
        tracks: [AudioTrackModel]
    ) {
        self.tracks = tracks
    }
    
    static func mock(_ id: Int) -> ArtistDetailModel {
        return ArtistDetailModel(
            tracks: [AudioTrackModel.mock(id), AudioTrackModel.mock(id + 1)]
        )
    }
    
    static func == (lhs: ArtistDetailModel, rhs: ArtistDetailModel) -> Bool {
        return lhs.tracks == rhs.tracks
    }
}

