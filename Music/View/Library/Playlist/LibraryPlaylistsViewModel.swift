//
//  LibraryPlaylistViewModel.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import Foundation
import Combine

class LibraryPlaylistsViewModel: ObservableObject {
    @Published private(set) var model: Stateful<LibraryPlaylistsModel> = .idle
//    @Published private(set) var model: Stateful<LibraryPlaylistsModel> = .loaded(LibraryPlaylistsModel.mock(1))
    private var cancellable: AnyCancellable?
    private let repository: LibraryPlaylistsRepository
    
    init(repository: LibraryPlaylistsRepository = LibraryPlaylistsDataRepository()) {
        self.repository = repository
        self.onAppear()
    }
    
    func onAppear() {
        guard model == .idle else { return }
        loadModel()
    }
    
    func onRetryButtonTapped() {
        loadModel()
    }
    
    private func loadModel() {
        cancellable = self.repository.fetchModel()
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
