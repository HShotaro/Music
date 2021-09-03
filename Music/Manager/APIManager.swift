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
            headerInfo: [String: String]? = nil
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
                    request.httpMethod = type.rawValue
                    request.timeoutInterval = 15
                    promise(.success(request))
                }
            }
            .compactMap{ $0 }.eraseToAnyPublisher()
    }
}
