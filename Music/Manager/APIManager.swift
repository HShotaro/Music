//
//  APIManager.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/24.
//

import Foundation
import Combine

final class APIManager {
    static let shared = APIManager()
    static let baseURL = "https://api.spotify.com/v1"
    enum APIError: Error {
            case failedToGetData
            case failedToPostData
            case failedToPutData
            case failedToDeleteData
            case clientError
            case serverError
        }
    enum HTTPMethod: String {
            case GET
            case POST
            case PUT
            case DELETE
        }
    static func createRequest(
            path: String,
            type: HTTPMethod,
            headerInfo: [String: String]? = nil,
            bodyInfo: [String: Any]? = nil
    ) -> AnyPublisher<URLRequest, Never>  {
        AuthManager.shared.withValidToken()
            .flatMap { token in
                return Future<URLRequest?, Never> { promise in
                    guard let apiURL = URL(string: baseURL + path), let token = token else {
                        promise(.success(nil))
                        return
                    }
                    var request = URLRequest(url: apiURL)
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    if let headerInfo = headerInfo {
                        headerInfo.forEach { (k,v) in
                            request.setValue(v, forHTTPHeaderField: k)
                        }
                    }
                    if let bodyInfo = bodyInfo {
                        request.httpBody = try? JSONSerialization.data(withJSONObject: bodyInfo, options: .fragmentsAllowed)
                    }
                    request.httpMethod = type.rawValue
                    request.timeoutInterval = 15
                    promise(.success(request))
                }
            }
            .compactMap{ $0 }.eraseToAnyPublisher()
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
