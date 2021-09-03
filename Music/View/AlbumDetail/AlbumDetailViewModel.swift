//
//  AlbumDetailViewModel.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/02.
//

import Foundation
import Combine

class AlbumDetailViewModel: ObservableObject {
    @Published private(set) var model: Stateful<AlbumDetailModel> = .idle
//    @Published private(set) var model: Stateful<AlbumDetailModel> = .loaded(AlbumDetailModel.mock(1))
    @Published var titleName = ""
    private var cancellable: AnyCancellable?
    private let repository: AlbumDetailRepository
    
    init(repository: AlbumDetailRepository = AlbumDetailDataRepository()) {
        self.repository = repository
    }
    
    func onAppear(album: AlbumModel) {
        guard model == .idle else { return }
        loadModel(album: album)
    }
    
    func onRetryButtonTapped(album: AlbumModel) {
        loadModel(album: album)
    }
    
    private func loadModel(album: AlbumModel) {
        cancellable = self.repository.fetchModel(for: album.id)
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
                self?.titleName = response.name
                self?.model = .loaded(response.exchangeAlbum(album: album))
            })
    }
}
