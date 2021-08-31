//
//  PlaylistView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/25.
//

import SwiftUI
import Combine

struct PlaylistDetailView: View {
    @EnvironmentObject var playerManager: MusicPlayerManager
    @StateObject private var viewModel = PlaylistDetailViewModel()
    @State var selectedButtonType: ButtonType? = nil
    let playlistID: String
    enum ButtonType: Identifiable {
        case playButton([AudioTrackModel])
        case list(AudioTrackModel)
        
        var id: String {
            switch self {
            case .playButton:
                return "playbutton"
            case let .list(track):
                return "list" + " " + track.id
            }
        }
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
                    Button(action: {}, label: {
                        EmptyView()
                    }).sheet(item: $selectedButtonType) {
                        self.selectedButtonType = nil
                    } content: { _ in
                        switch self.selectedButtonType {
                        case let .playButton(tracks):
                            MusicPlayerView(audioTracks: tracks)
                        case let .list(track):
                            MusicPlayerView(audioTracks: [track])
                        case .none:
                            EmptyView()
                        }
                    }
                    let playButtonBinding = Binding<Bool>(
                        get: {
                            switch self.selectedButtonType {
                            case .playButton: return true
                            default: return false
                            }
                        },
                        set: { value in
                            self.selectedButtonType = value ? .playButton(model.tracks) : nil
                        }
                    )
                    List {
                        ForEach(0..<model.tracks.count+1) {(row: Int) in
                            if row > 0 {
                                let track = model.tracks[row-1]
                                Button(action: {
                                    self.selectedButtonType = .list(track)
                                }, label: {
                                    ListItemLayout1View(
                                        titleName: track.name,
                                        subTitleName: track.artist.name
                                    )
                                })
                            } else {
                                LargeImageLayout1View(showPlayerView: playButtonBinding, imageURL: model.imageURL)
                                    .buttonStyle(StaticBackgroundButtonStyle())
                            }
                        }
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
                .environment(\.colorScheme, .dark)
                .environment(\.locale, Locale(identifier: "en"))
                .previewDisplayName("English")
            
        }
    }
}
