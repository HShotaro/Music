//
//  LibraryAlbumViewModel.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import Foundation
import Combine

class LibraryAlbumListViewModel: ObservableObject {
    @Published private(set) var model: Stateful<LibraryAlbumlistModel> = .idle
//    @Published private(set) var model: Stateful<LibraryAlbumlistModel> = .loaded(LibraryAlbumlistModel.mock(1))
    private var cancellable: AnyCancellable?
    private let repository: LibraryAlbumListRepository
    
    init(repository: LibraryAlbumListRepository = LibraryAlbumListDataRepository()) {
        self.repository = repository
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
    
    func deleteAlbumFromLibrary(album: AlbumModel) {
        guard case .loaded(let rawModel) = model else { return }
        cancellable = self.repository.deleteAlbumFromLibrary(albumID: album.id)
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
                let albums = rawModel.albumList.filter { album != $0 }
                self?.model = .loaded(LibraryAlbumlistModel(albumList: albums))
            })
    }
}
