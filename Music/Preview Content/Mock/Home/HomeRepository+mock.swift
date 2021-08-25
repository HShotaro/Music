//
//  HomeRepository+mock.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/25.
//

import Foundation
import Combine

struct HomeMockRepository: HomeRepository {
    let error: Error?
    let model: HomeModel
    
    init(playlists: [PlayListModel]) {
        self.model = HomeModel(playlists: playlists)
        self.error = nil
    }
    
    init(playlists: [PlayListModel], error: Error) {
        self.model = HomeModel(playlists: playlists)
        self.error = error
    }
    
    func fetchModel() -> AnyPublisher<HomeModel, Error> {
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

