//
//  PlaylistModelViewModel.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/04.
//

import Foundation
import Combine

class PlaylistModalViewModel: ObservableObject {
    @Published private(set) var model: PlaylistModalView.Stateful = .idle
    private var cancellable: AnyCancellable?
    private let repository: PlaylistModalRepository
    
    init(repository: PlaylistModalRepository = PlaylistModalDataRepository()) {
        self.repository = repository
        loadModel()
    }
    
    func onRetryButtonTapped() {
        loadModel()
    }
    
    private func loadModel() {
        cancellable = self.repository.fetchCurrentUserPlaylist()
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
                self?.model = .loaded(response.playlists)
            })
    }
    
    func addTrackToPlaylist(playlistID: String, trackID: String) {
        cancellable = self.repository.addTrackToPlaylist(playlistID: playlistID, trackID: trackID)
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
                self?.model = .addedTrackToPlaylist
            })
    }
}
