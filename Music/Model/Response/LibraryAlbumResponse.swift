//
//  LibraryAlbumResponse.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import Foundation

struct LibraryAlbumResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let album: Album
    let added_at: String?
}

struct LibraryAlbumlistModel: Equatable {
    let albumList: [AlbumModel]
    
    init(rawModel: LibraryAlbumResponse) {
        albumList = rawModel.items.map { AlbumModel(rawModel: $0.album) }
    }
    
    init(
        albumList: [AlbumModel]
    ) {
        self.albumList = albumList
    }
    
    static func mock(_ id: Int) -> LibraryAlbumlistModel {
        return LibraryAlbumlistModel(
            albumList: [AlbumModel.mock(id), AlbumModel.mock(id + 1)]
            )
    }
    
    static func == (lhs: LibraryAlbumlistModel, rhs: LibraryAlbumlistModel) -> Bool {
        return lhs.albumList == rhs.albumList
    }
}
