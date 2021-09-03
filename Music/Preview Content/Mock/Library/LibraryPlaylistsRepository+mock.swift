//
//  LibraryPlaylistsRepository+mock.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import Foundation
import Combine

struct LibraryPlayListsMockRepository: LibraryPlaylistsRepository {
    let error: Error?
    let model: LibraryPlaylistsModel
    
    init(model: LibraryPlaylistsModel) {
        self.model = model
        self.error = nil
    }
    
    init(model: LibraryPlaylistsModel, error: Error) {
        self.model = model
        self.error = error
    }
    
    func fetchCurrentUserPlaylistsModel() -> AnyPublisher<LibraryPlaylistsModel, Error> {
        if let error = error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        } else {
            return Just(model)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
