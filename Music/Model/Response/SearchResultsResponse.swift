//
//  SearchResultsResponse.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import Foundation

struct SearchResultsResponse: Codable {
    let albums: SearchAlbumResponse
    let artists: SearchArtistsResponse
    let playlists: SearchPlaylistsResponse
    let tracks: SearchTracksResponse
}

enum SearchResultType: Equatable {
    case artist(model: ArtistModel)
    case album(model: AlbumModel)
    case track(model: AudioTrackModel)
    case playlist(model: PlayListModel)
    
    static func == (lhs: SearchResultType, rhs: SearchResultType) -> Bool {
        switch (lhs, rhs) {
        case (let .artist(l), let .artist(r)):
            return l.id == r.id
        case (let .album(l), let .album(r)):
            return l.id == r.id
        case (let .track(l), let .track(r)):
            return l.id == r.id
        case (let .playlist(l), let .playlist(r)):
            return l.id == r.id
        default:
            return false
        }
    }
}

struct SearchAlbumResponse: Codable {
    let items: [AlbumModel]
}

struct SearchArtistsResponse: Codable {
    let items: [ArtistModel]
}

struct SearchPlaylistsResponse: Codable {
    let items: [PlayListModel]
}

struct SearchTracksResponse: Codable {
    let items: [AudioTrackModel]
}

struct SearchResultsModel : Equatable {
    let albums: [AlbumModel]
    let artists: [ArtistModel]
    let playlists: [PlayListModel]
    let tracks: [AudioTrackModel]
    
    init(rawModel: SearchResultsResponse) {
        albums = rawModel.albums.items
        artists = rawModel.artists.items
        playlists = rawModel.playlists.items
        tracks = rawModel.tracks.items.filter{ $0.previewURL != nil }
    }
    
    init(
        albums: [AlbumModel],
        artists: [ArtistModel],
        playlists: [PlayListModel],
        tracks: [AudioTrackModel]
    ) {
        self.albums = albums
        self.artists = artists
        self.playlists = playlists
        self.tracks = tracks
    }
    
    static func mock() -> SearchResultsModel {
        return SearchResultsModel(
            albums: [AlbumModel.mock(1), AlbumModel.mock(2)],
            artists: [ArtistModel.mock(1), ArtistModel.mock(2)],
            playlists: [PlayListModel.mock(1), PlayListModel.mock(2)],
            tracks: [AudioTrackModel.mock(1), AudioTrackModel.mock(2)]
        )
    }
    
    static func == (lhs: SearchResultsModel, rhs: SearchResultsModel) -> Bool {
        return lhs.albums == rhs.albums &&
                lhs.artists == rhs.artists &&
                lhs.playlists == rhs.playlists &&
                lhs.tracks == rhs.tracks
    }
}
