//
//  ArtistDetailRepository.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import Foundation
import Combine

protocol ArtistDetailRepository {
    func fetchModel(for artistID: String) -> AnyPublisher<ArtistDetailModel, Error>
}

struct ArtistDetailDataRepository: ArtistDetailRepository {
    func fetchModel(for artistID: String) -> AnyPublisher<ArtistDetailModel, Error> {
        return APIManager.shared.getArtistTopTracksModel(for: artistID)
    }
}

fileprivate extension APIManager {
    func getArtistTopTracksModel(for artistID: String) -> AnyPublisher<ArtistDetailModel, Error> {
        return APIManager.createRequest(path: "/artists/\(artistID)/top-tracks?market=JP", type: .GET)
            .flatMap { request in
                URLSession.shared.dataTaskPublisher(for: request)
                .tryMap() { element -> ArtistDetailModel in
                    guard let response = element.response as? HTTPURLResponse else {
                        throw APIError.failedToGetData
                    }
                    guard response.statusCode < 500 else {
                        print("Status Code\(response.statusCode)")
                        throw APIError.serverError
                    }
                    guard response.statusCode < 400 else {
                        print("Status Code\(response.statusCode)")
                        throw APIError.clientError
                    }
                    do {
                        let result = try JSONDecoder().decode(ArtistTopTracksDataResponse.self, from: element.data)
                        let model = ArtistDetailModel(rawModel: result)
                        return model
                    }
                    catch {
                        throw error
                    }
                }
        }.eraseToAnyPublisher()
    }
}

