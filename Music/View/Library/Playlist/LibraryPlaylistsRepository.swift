//
//  LibraryPlaylistRepository.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import Foundation
import Combine

protocol LibraryPlaylistsRepository {
    func fetchCurrentUserPlaylistsModel() -> AnyPublisher<LibraryPlaylistsModel, Error>
}

struct LibraryPlaylistsDataRepository: LibraryPlaylistsRepository {
    func fetchCurrentUserPlaylistsModel() -> AnyPublisher<LibraryPlaylistsModel, Error> {
        return APIManager.getCurrentUserPlaylistsModel()
    }
}
