//
//  PlaylistModelRepository.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/04.
//

import Foundation
import Combine

protocol PlaylistModalRepository {
    func fetchCurrentUserPlaylist() -> AnyPublisher<LibraryPlaylistsModel, Error>
    func addTrackToPlaylist(playlistID: String, trackID: String) -> AnyPublisher<Void, Error>
}

struct PlaylistModalDataRepository: PlaylistModalRepository {
    func fetchCurrentUserPlaylist() -> AnyPublisher<LibraryPlaylistsModel, Error> {
        return APIManager.getCurrentUserPlaylistsModel()
    }
    
    func addTrackToPlaylist(playlistID: String, trackID: String) -> AnyPublisher<Void, Error> {
        return APIManager.shared.addTrackToPlaylist(playlistID: playlistID, trackID: trackID)
    }
}

fileprivate extension APIManager {
    func addTrackToPlaylist(playlistID: String, trackID: String) -> AnyPublisher<Void, Error> {
        return APIManager.createRequest(path: "/playlists/\(playlistID)/tracks", type: .POST, headerInfo: ["Content-Type":"application/json"],
            bodyInfo: ["uris": ["spotify:track:\(trackID)"]]
        )
            .flatMap { request in
                URLSession.shared.dataTaskPublisher(for: request)
                .tryMap() { element -> Void in
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
                        let result = try JSONSerialization.jsonObject(with: element.data, options: .allowFragments)
                        if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                            return
                        } else {
                            throw APIError.failedToPostData
                        }
                    } catch {
                        throw error
                    }
                }
        }.eraseToAnyPublisher()
    }
}
