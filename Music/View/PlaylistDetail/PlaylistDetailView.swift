//
//  PlaylistView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/25.
//

import SwiftUI
import Combine

struct PlaylistDetailView: View {
    @StateObject private var viewModel: PlaylistDetailViewModel
    
    init(playlistID: String, viewModel: PlaylistDetailViewModel = PlaylistDetailViewModel()) {
        viewModel.playlistID = playlistID
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            switch viewModel.model {
            case .idle, .loading:
                ProgressView("loading...")
            case .failed(_):
                VStack {
                    Group {
                        Image("default_icon")
                        Text("ページの読み込みに失敗しました。")
                            .padding(.top, 4)
                    }
                    .foregroundColor(.black)
                    .opacity(0.4)
                    Button(
                        action: {
                            viewModel.onRetryButtonTapped()
                        }, label: {
                            Text("リトライ")
                                .fontWeight(.bold)
                        }
                    )
                    .padding(.top, 8)
                }
            case let .loaded(model):
                if model.tracks.isEmpty {
                    Text("このプレイリストには曲がありません。")
                        .fontWeight(.bold)
                } else {
                    VStack {
                        LargeImageLayout1View(
                            imageURL: model.imageURL,
                            titleName: model.name
                        )
                        Divider()
                    }
                    List(model.tracks) { track in
                        NavigationLink(
                            destination:
                                HomeView(),
                            label: {
                                ListItemLayout1View(
                                    titleName: track.name,
                                    subTitleName: track.artist.name
                                )
                            }
                        )
                    }
                }
            }
        }.onAppear {
            viewModel.onAppear()
        }.navigationTitle(viewModel.titleName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlaylistDetailView(
                playlistID: "1", viewModel: PlaylistDetailViewModel(
                    repository:
                        PlaylistDetailMockRepository(
                            playlistDetailModel: PlaylistDetailModel.mock(1)
                        )
                )
            )
            .previewDisplayName("Default")
            
            PlaylistDetailView(
                playlistID: "1", viewModel: PlaylistDetailViewModel(
                    repository:
                        PlaylistDetailMockRepository(
                            playlistDetailModel: PlaylistDetailModel.mock(1, hasTrack: false)
                        )
                )
            )
            .previewDisplayName("Empty")
            
            PlaylistDetailView(
                playlistID: "1", viewModel: PlaylistDetailViewModel(
                    repository:
                        PlaylistDetailMockRepository(
                            playlistDetailModel: PlaylistDetailModel.mock(1, hasTrack: false),
                            error: DummyError()
                        )
                )
            )
            .previewDisplayName("Error")
        }
    }
}
