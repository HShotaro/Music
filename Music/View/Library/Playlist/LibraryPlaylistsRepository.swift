//
//  LibraryPlaylistRepository.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import Foundation
import Combine

protocol LibraryPlaylistsRepository {
    func fetchModel() -> AnyPublisher<LibraryPlaylistsModel, Error>
}

struct LibraryPlaylistsDataRepository: LibraryPlaylistsRepository {
    func fetchModel() -> AnyPublisher<LibraryPlaylistsModel, Error> {
        return APIManager.shared.getCurrentUserPlaylistsModel()
    }
}

fileprivate extension APIManager {
    func getCurrentUserPlaylistsModel() -> AnyPublisher<LibraryPlaylistsModel, Error> {
        return APIManager.createRequest(path: "/me/playlists", type: .GET)
            .flatMap { request in
                URLSession.shared.dataTaskPublisher(for: request)
                .tryMap() { element -> LibraryPlaylistsModel in
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
                        let result = try JSONDecoder().decode(LibraryPlaylistsResponse.self, from: element.data)
                        let model = LibraryPlaylistsModel(rawModel: result)
                        return model
                    }
                    catch {
                        throw error
                    }
                }
        }.eraseToAnyPublisher()
    }
}
