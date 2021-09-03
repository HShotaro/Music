//
//  LibraryAlbumListViewModelTests.swift
//  MusicTests
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import XCTest
import Combine
@testable import Music

class LibraryAlbumListViewModelTests: XCTestCase {
    private var cancelables = Set<AnyCancellable>()
    override func setUpWithError() throws {
        cancelables = .init()
    }
    
    func test_onAppear_success() {
        let expectedToBeloading = expectation(description: "読み込み中のステータスになること")
        let expectedToBeloded = expectation(description: "期待通り雑誌一覧が読み込まれること")
        let viewModel = LibraryAlbumListViewModel(
            repository: LibraryAlbumListMockRepository(
                model: LibraryAlbumlistModel.mock(1)
            )
        )
        
        viewModel.$model.sink { result in
            switch result {
            case .loading: expectedToBeloading.fulfill()
            case let .loaded(model):
                if model.albumList.count == 2 && model.albumList.map ({ $0.id }) == [LibraryAlbumlistModel.mock(1).albumList[0].id, LibraryAlbumlistModel.mock(1).albumList[1].id] {
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

