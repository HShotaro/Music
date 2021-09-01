//
//  PlaylistView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/25.
//

import SwiftUI
import Combine

struct PlaylistDetailView: View {
    @StateObject private var viewModel = PlaylistDetailViewModel()
    @EnvironmentObject var playerManager: MusicPlayerManager
    let playlistID: String

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
                            viewModel.onRetryButtonTapped(playlistID: playlistID)
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
                    List {
                        ForEach(0..<model.tracks.count+1) {(row: Int) in
                            if row > 0 {
                                let track = model.tracks[row-1]
                                Button(action: {
                                    withAnimation {
                                        playerManager.showMusicPlayer(tracks: [track])
                                    }
                                }, label: {
                                    ListItemLayout1View(
                                        titleName: track.name,
                                        subTitleName: track.artist.name
                                    )
                                })
                            } else {
                                LargeImageLayout1View(imageURL: model.imageURL, tracks: model.tracks)
                                    .buttonStyle(StaticBackgroundButtonStyle())
                            }
                        }
                    }
                    if playerManager.currentTrack != nil {
                        Spacer(minLength: MusicPlayerView.height)
                    }
                }
            }
        }.onAppear {
            viewModel.onAppear(playlistID: playlistID)
        }
        .navigationTitle(viewModel.titleName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlaylistDetailView(
                playlistID: "1"
            )
            .environment(\.colorScheme, .light)
            .previewDisplayName("light")
            
            PlaylistDetailView(playlistID: "2")
                .environment(\.colorScheme, .dark)
                .previewDisplayName("dark")
            PlaylistDetailView(playlistID: "2")
                .environment(\.locale, Locale(identifier: "en"))
                .previewDisplayName("English")
            
        }
    }
}
