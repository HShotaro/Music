//
//  AlbumDetailRepository+mock.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import Foundation
import Combine

struct AlbumDetailMockRepository: AlbumDetailRepository {
    let error: Error?
    let model: AlbumDetailModel
    
    init(albumDetailModel: AlbumDetailModel) {
        self.model = albumDetailModel
        self.error = nil
    }
    
    init(albumDetailModel: AlbumDetailModel, error: Error) {
        self.model = albumDetailModel
        self.error = error
    }
    
    func fetchModel(for albumID: String) -> AnyPublisher<AlbumDetailModel, Error> {
        if let error = error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        } else {
            return Just(model)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func addAlbumToLibrary(albumID: String) -> AnyPublisher<Void, Error> {
        if let error = error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        } else {
            return Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}



