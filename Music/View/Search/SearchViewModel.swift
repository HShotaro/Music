//
//  SearchViewModel.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published private(set) var model: Stateful<SearchResultsModel> = .idle
//    @Published private(set) var model: Stateful<SearchResultsModel> = .loaded(SearchResultsModel.mock())
    private var cancellable: AnyCancellable?
    private let repository: SearchRepository
    
    init(repository: SearchRepository = SearchDataRepository()) {
        self.repository = repository
    }
    
    func search(with query: String) {
        loadModel(with: query)
    }
    
    func onRetryButtonTapped(with query: String) {
        loadModel(with: query)
    }
    
    private func loadModel(with query: String) {
        cancellable = self.repository.fetchModel(with: query)
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.model = .loading
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.model = .failed(error)
                case .finished:
                    break
                }
                self?.cancellable = nil
            }, receiveValue: { [weak self] response in
                self?.model = .loaded(response)
            })
    }
}

