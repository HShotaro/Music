//
//  PlaylistDetailRepository+mock.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import Foundation
import Combine

struct PlaylistDetailMockRepository: PlaylistDetailRepository {
    let error: Error?
    let model: PlaylistDetailModel
    
    init(playlistDetailModel: PlaylistDetailModel) {
        self.model = playlistDetailModel
        self.error = nil
    }
    
    init(playlistDetailModel: PlaylistDetailModel, error: Error) {
        self.model = playlistDetailModel
        self.error = error
    }
    
    func fetchModel(for playlistID: String) -> AnyPublisher<PlaylistDetailModel, Error> {
        if let error = error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        } else {
            return Just(model)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func removeTrackFromPlaylist(playlistID: String, trackID: String) -> AnyPublisher<Void, Error> {
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


