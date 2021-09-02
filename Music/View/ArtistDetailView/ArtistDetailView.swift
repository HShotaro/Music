//
//  ArtistDetailView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import SwiftUI

struct ArtistDetailView: View {
    @StateObject private var viewModel = ArtistDetailViewModel()
    @EnvironmentObject var playerManager: MusicPlayerManager
    let artistID: String

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
                            viewModel.onRetryButtonTapped(artistID: artistID)
                        }, label: {
                            Text("リトライ")
                                .fontWeight(.bold)
                        }
                    )
                    .padding(.top, 8)
                }
            case let .loaded(model):
                if model.tracks.isEmpty {
                    Text("曲がありません。")
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
                                    ListItem_Title_SubTitle_View(
                                        titleName: track.name,
                                        subTitleName: track.artist.name
                                    )
                                })
                            } else {
                                Image_PlayerButton_View(imageURL: model.tracks.first?.album.imageURL, tracks: model.tracks)
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
            viewModel.onAppear(artistID: artistID)
        }
        .navigationTitle(viewModel.titleName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ArtistDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistDetailView(artistID: ArtistModel.mock(1).id)
    }
}
