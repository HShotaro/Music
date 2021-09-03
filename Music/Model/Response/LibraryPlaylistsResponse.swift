//
//  LibraryPlaylistsResponse.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import Foundation

struct LibraryPlaylistsResponse: Codable {
    let items: [Playlist]
}

struct LibraryPlaylistsModel: Equatable {
    let playlists: [PlayListModel]
    
    init(rawModel: LibraryPlaylistsResponse) {
        playlists = rawModel.items.map { PlayListModel(rawModel: $0) }
    }
    
    init(
        playlists: [PlayListModel]
    ) {
        self.playlists = playlists
    }
    
    static func mock(_ id: Int) -> LibraryPlaylistsModel {
        return LibraryPlaylistsModel(
            playlists: [PlayListModel.mock(id), PlayListModel.mock(id + 1)]
        )
    }
    
    static func == (lhs: LibraryPlaylistsModel, rhs: LibraryPlaylistsModel) -> Bool {
        return lhs.playlists == rhs.playlists
    }
}
