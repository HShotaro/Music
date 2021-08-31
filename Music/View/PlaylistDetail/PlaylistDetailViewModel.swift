//
//  PlaylistDetailViewModel.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import Foundation
import Combine

class PlaylistDetailViewModel: ObservableObject {
    @Published private(set) var model: Stateful<PlaylistDetailModel> = .idle
//    @Published private(set) var model: Stateful<PlaylistDetailModel> = .loaded(PlaylistDetailModel.mock(1))
    @Published var titleName = ""
    private var cancellable: AnyCancellable?
    private let repository: PlaylistDetailRepository
    
    init(repository: PlaylistDetailRepository = PlaylistDetailDataRepository()) {
        self.repository = repository
    }
    
    func onAppear(playlistID: String) {
        loadModel(playlistID: playlistID)
    }
    
    func onRetryButtonTapped(playlistID: String) {
        loadModel(playlistID: playlistID)
    }
    
    private func loadModel(playlistID: String) {
        cancellable = self.repository.fetchModel(for: playlistID)
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
            }, receiveValue: { [weak self] response in
                self?.titleName = response.name
                self?.model = .loaded(response)
            }
            )
    }
}
