//
//  HomeViewModelTests.swift
//  MusicTests
//
//  Created by Shotaro Hirano on 2021/08/25.
//

import XCTest
import Combine
@testable import Music

class HomeViewModelTests: XCTestCase {
    private var cancelables = Set<AnyCancellable>()
    override func setUpWithError() throws {
        cancelables = .init()
    }
    
    func test_onAppear_success() {
        let expectedToBeloading = expectation(description: "読み込み中のステータスになること")
        let expectedToBeloded = expectation(description: "期待通り雑誌一覧が読み込まれること")
        let viewModel = HomeViewModel(
            repository: HomeMockRepository(
                playlists: [.mock(1), .mock(2)]
            )
        )
        
        viewModel.$model.sink { result in
            switch result {
            case .loading: expectedToBeloading.fulfill()
            case let .loaded(model):
                if model.playlists.count == 2 && model.playlists.map ({ $0.id }) == [PlayListModel.mock(1).id, PlayListModel.mock(2).id] {
                    expectedToBeloded.fulfill()
                } else {
                    XCTFail("Unexpected: \(result)")
                }
            case .failed, .idle:
                break
            }
        }.store(in: &cancelables)
        
        viewModel.onAppear()
        
        wait(for: [expectedToBeloading, expectedToBeloded],
             timeout: 2.0,
             enforceOrder: true // for: []の順番通りに呼ばれるかどうかを検証するようにする
        )
    }
}
