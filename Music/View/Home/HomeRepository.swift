//
//  HomeRepository.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/24.
//

import Foundation
import Combine

protocol HomeRepository {
    func fetchModel() -> AnyPublisher<HomeModel, Error>
}

struct HomeDataRepository: HomeRepository {
    func fetchModel() -> AnyPublisher<HomeModel, Error> {
        return APIManager.shared.getFeaturedPlaylists()
    }
}

fileprivate extension APIManager {
    func getFeaturedPlaylists() -> AnyPublisher<HomeModel, Error> {
        return APIManager.createRequest(path: "/browse/featured-playlists?limit=20&country=JP", type: .GET)
            .flatMap { request in
                URLSession.shared.dataTaskPublisher(for: request)
                .tryMap() { element -> HomeModel in
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
                        let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: element.data)
                        let model = HomeModel(playlists: result.playlists.items.map { PlayListModel(rawModel: $0) })
                        return model
                    }
                    catch {
                        throw error
                    }
                }
        }.eraseToAnyPublisher()
    }
}

struct HomeModel: Equatable {
    let playlists: [PlayListModel]
}
