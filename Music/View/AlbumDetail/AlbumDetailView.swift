//
//  AlbumDetailView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/02.
//

import SwiftUI

struct AlbumDetailView: View {
    @StateObject private var viewModel = AlbumDetailViewModel()
    @EnvironmentObject var playerManager: MusicPlayerManager
    let album: AlbumModel

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
                            viewModel.onRetryButtonTapped(album: album)
                        }, label: {
                            Text("リトライ")
                                .fontWeight(.bold)
                        }
                    )
                    .padding(.top, 8)
                }
            case let .loaded(model):
                if model.tracks.isEmpty {
                    Text("このアルバムには曲がありません。")
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
                                ShowPlayerLayout1View(imageURL: model.imageURL, tracks: model.tracks)
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
            viewModel.onAppear(album: album)
        }
        .navigationTitle(viewModel.titleName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AlbumDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumDetailView(album: AlbumModel.mock(1))
    }
}
