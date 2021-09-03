//
//  PlaylistDetailRepository.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import Foundation
import Combine

protocol PlaylistDetailRepository {
    func fetchModel(for playlistID: String) -> AnyPublisher<PlaylistDetailModel, Error>
    func removeTrackFromPlaylist(playlistID: String, trackID: String) -> AnyPublisher<Void, Error>
}

struct PlaylistDetailDataRepository: PlaylistDetailRepository {
    func fetchModel(for playlistID: String) -> AnyPublisher<PlaylistDetailModel, Error> {
        return APIManager.shared.getPlaylistDetailModel(for: playlistID)
    }
    
    func removeTrackFromPlaylist(playlistID: String, trackID: String) -> AnyPublisher<Void, Error> {
        return APIManager.shared.removeTrackFromPlaylist(playlistID: playlistID, trackID: trackID)
    }
}

fileprivate extension APIManager {
    func getPlaylistDetailModel(for playlistID: String) -> AnyPublisher<PlaylistDetailModel, Error> {
        return APIManager.createRequest(path: "/playlists/\(playlistID)", type: .GET)
            .flatMap { request in
                URLSession.shared.dataTaskPublisher(for: request)
                .tryMap() { element -> PlaylistDetailModel in
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
                        let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: element.data)
                        let model = PlaylistDetailModel(rawModel: result)
                        return model
                    }
                    catch {
                        throw error
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func removeTrackFromPlaylist(playlistID: String, trackID: String) -> AnyPublisher<Void, Error> {
        return APIManager.createRequest(path: "/playlists/\(playlistID)/tracks", type: .DELETE, headerInfo: ["Content-Type":"application/json"],
            bodyInfo: ["tracks":[["uri": "spotify:track:\(trackID)"]]]
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
                            throw APIError.failedToDeleteData
                        }
                    } catch {
                        throw error
                    }
                }
        }.eraseToAnyPublisher()
    }
}
