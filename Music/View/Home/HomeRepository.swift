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
        return Publishers.CombineLatest(
            APIManager.shared.getFeaturedPlaylists(),
            APIManager.shared.getNewReleaseAlbums()
        ).flatMap { tuple in
            return Future<HomeModel, Error> { promise in
                promise(.success(HomeModel(playlists: tuple.0, albums: tuple.1)))
            }
        }.eraseToAnyPublisher()
    }
}

fileprivate extension APIManager {
    func getNewReleaseAlbums() -> AnyPublisher<[AlbumModel], Error> {
        return APIManager.createRequest(path: "/browse/new-releases?limit=50&country=JP", type: .GET)
            .flatMap { request in
                URLSession.shared.dataTaskPublisher(for: request)
                .tryMap() { element -> [AlbumModel] in
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
                        let result = try JSONDecoder().decode(NewReleasesResponse.self, from: element.data)
                        let model = result.albums.items.map { AlbumModel(rawModel: $0) }
                        return model
                    }
                    catch {
                        throw error
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func getFeaturedPlaylists() -> AnyPublisher<[PlayListModel], Error> {
        return APIManager.createRequest(path: "/browse/featured-playlists?limit=20&country=JP", type: .GET)
            .flatMap { request in
                URLSession.shared.dataTaskPublisher(for: request)
                .tryMap() { element -> [PlayListModel] in
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
                        let model = result.playlists.items.map { PlayListModel(rawModel: $0) }
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
    let albums: [AlbumModel]
}
