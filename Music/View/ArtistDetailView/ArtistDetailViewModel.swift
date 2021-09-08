//
//  ArtistDetailViewModel.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import Foundation
import Combine

class ArtistDetailViewModel: ObservableObject {
    @Published private(set) var model: Stateful<ArtistDetailModel> = .idle
//    @Published private(set) var model: Stateful<ArtistDetailModel> = .loaded(ArtistDetailModel.mock(1))
    @Published var titleName = ""
    private var cancellable: AnyCancellable?
    private let repository: ArtistDetailRepository
    
    var longPressedTrack: AudioTrackModel?
    
    init(repository: ArtistDetailRepository = ArtistDetailDataRepository()) {
        self.repository = repository
    }
    
    func onAppear(artistID: String) {
        guard model == .idle else { return }
        loadModel(artistID: artistID)
    }
    
    func onRetryButtonTapped(artistID: String) {
        loadModel(artistID: artistID)
    }
    
    private func loadModel(artistID: String) {
        cancellable = self.repository.fetchModel(for: artistID)
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
                self?.titleName = response.tracks.first?.artist.name ?? ""
                self?.model = .loaded(response)
            })
    }
}

