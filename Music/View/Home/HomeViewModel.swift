//
//  HomeViewModel.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published private(set) var model: Stateful<HomeModel> = .idle
//    @Published private(set) var model: Stateful<HomeModel> = .loaded(HomeModel(playlists: [Int](1...50).map { PlayListModel.mock($0) }))
    private var cancellable: AnyCancellable?
    private let repository: HomeRepository
    
    init(repository: HomeRepository = HomeDataRepository()) {
        self.repository = repository
    }
    
    func onAppear() {
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
            }, receiveValue: { [weak self] response in
                self?.model = .loaded(response)
                
            }
            )
    }
}
