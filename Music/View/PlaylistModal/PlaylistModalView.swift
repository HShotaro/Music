//
//  PlaylistModelView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/04.
//

import SwiftUI

struct PlaylistModalView: View {
    @StateObject var viewModel = PlaylistModalViewModel()
    @Binding var showModalView: Bool
    @State var path: [SMPageDestination] = []
    enum Stateful: Equatable {
        case idle
        case loading
        case failed(Error)
        case loaded([PlayListModel])
        case addedTrackToPlaylist
        
        static func == (lhs: PlaylistModalView.Stateful, rhs: PlaylistModalView.Stateful) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle):
                return true
            case (.loading, loading):
                return true
            case (.failed, .failed):
                return true
            case (let .loaded(l), let .loaded(r)):
                return l == r
            case (.addedTrackToPlaylist, .addedTrackToPlaylist):
                return true
            default:
                return false
            }
        }
    }
    let trackID: String
    var body: some View {
        SMNavigationView(navigationTitle: "追加するプレイリストを選んでください", path: $path) {
            VStack {
                switch viewModel.model {
                case .idle:
                    EmptyView()
                case .loading:
                    ProgressView("loading...")
                case .failed:
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
                case let .loaded(playlists):
                    List(playlists, id: \.self.id) { playlist in
                        Button {
                            viewModel.addTrackToPlaylist(playlistID: playlist.id, trackID: trackID)
                        } label: {
                            Text(playlist.name)
                        }
                    }
                case .addedTrackToPlaylist:
                    EmptyView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: viewModel.model) { model in
                guard case .addedTrackToPlaylist = model else { return }
                self.showModalView = false
            }
        }
    }
}

struct PlaylistModelView_Previews: PreviewProvider {
    @State static var showModalView = true
    static var previews: some View {
        PlaylistModalView(showModalView: $showModalView, trackID: AudioTrackModel.mock(1).id)
    }
}
