//
//  LibraryAlbumRepository.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import Foundation
import Combine

protocol LibraryAlbumListRepository {
    func fetchModel() -> AnyPublisher<LibraryAlbumlistModel, Error>
}

struct LibraryAlbumListDataRepository: LibraryAlbumListRepository {
    func fetchModel() -> AnyPublisher<LibraryAlbumlistModel, Error> {
        return APIManager.shared.getCurrentUserAlbumlistModel()
    }
}

fileprivate extension APIManager {
    func getCurrentUserAlbumlistModel() -> AnyPublisher<LibraryAlbumlistModel, Error> {
        return APIManager.createRequest(path: "/me/albums", type: .GET)
            .flatMap { request in
                URLSession.shared.dataTaskPublisher(for: request)
                .tryMap() { element -> LibraryAlbumlistModel in
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
                        let result = try JSONDecoder().decode(LibraryAlbumResponse.self, from: element.data)
                        let model = LibraryAlbumlistModel(rawModel: result)
                        return model
                    }
                    catch {
                        throw error
                    }
                }
        }.eraseToAnyPublisher()
    }
}
