//
//  LibraryAlbumlistRepository+mock.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import Foundation
import Combine

struct LibraryAlbumListMockRepository: LibraryAlbumListRepository {
    let error: Error?
    let model: LibraryAlbumlistModel
    
    init(model: LibraryAlbumlistModel) {
        self.model = model
        self.error = nil
    }
    
    init(model: LibraryAlbumlistModel, error: Error) {
        self.model = model
        self.error = error
    }
    
    func fetchModel() -> AnyPublisher<LibraryAlbumlistModel, Error> {
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
