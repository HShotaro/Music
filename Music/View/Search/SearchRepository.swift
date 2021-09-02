//
//  SearchRepository.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import Foundation
import Combine

protocol SearchRepository {
    func fetchModel(with query: String) -> AnyPublisher<SearchResultsModel, Error>
}

struct SearchDataRepository: SearchRepository {
    func fetchModel(with query: String) -> AnyPublisher<SearchResultsModel, Error> {
        return APIManager.shared.getSearchResultsModel(with: query)
    }
}

fileprivate extension APIManager {
    func getSearchResultsModel(with query: String) -> AnyPublisher<SearchResultsModel, Error> {
        return APIManager.createRequest(path: "/search?limit=10&type=album,artist,playlist,track&market=JP&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")", type: .GET)
            .flatMap { request in
                URLSession.shared.dataTaskPublisher(for: request)
                .tryMap() { element -> SearchResultsModel in
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
                        let result = try JSONDecoder().decode(SearchResultsResponse.self, from: element.data)
                        let model = SearchResultsModel(rawModel: result)
                        return model
                    }
                    catch {
                        throw error
                    }
                }
        }.eraseToAnyPublisher()
    }
}

