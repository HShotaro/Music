//
//  ArtistDetail+.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import Foundation
import Combine

struct ArtistDetailMockRepository: ArtistDetailRepository {
    
    let error: Error?
    let model: ArtistDetailModel
    
    init(artistDetailModel: ArtistDetailModel) {
        self.model = artistDetailModel
        self.error = nil
    }
    
    init(artistDetailModel: ArtistDetailModel, error: Error) {
        self.model = artistDetailModel
        self.error = error
    }
    
    func fetchModel(for artistID: String) -> AnyPublisher<ArtistDetailModel, Error> {
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
