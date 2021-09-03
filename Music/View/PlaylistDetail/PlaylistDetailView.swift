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
    // Listの中の要素(AudioTrackModel)はButtonのアクション・onTapGesture・onLongPressGestureなどで取得できるが、alert modifier、sheet modifierの中で使用してしまうと上手く取得できない(Listの中のランダムな要素を取得してしまう)。
    // そのため、alertやsheetでListの中の要素を使用する場合は、longPressedTrackのように一旦モデルを保持してから使用するようにした。
    @State var longPressedTrack: AudioTrackModel?
    @State var showAlertOnLongPress = false
    @State var showPlaylistModelView = false
    let playlistID: String
    let isOwner: Bool
    
    var body: some View {
        VStack {
            switch viewModel.model {
            case .idle:
                EmptyView()
            case .loading:
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
                        ForEach(0..<model.tracks.count+1, id: \.self) {(row: Int) in
                            if row > 0 {
                                let track = model.tracks[row-1]
                                ListItem_Title_SubTitle_View(
                                    titleName: track.name,
                                    subTitleName: track.artist.name
                                )
                                .onTapGesture {
                                    withAnimation {
                                        playerManager.showMusicPlayer(tracks: [track])
                                    }
                                }
                                .onLongPressGesture(minimumDuration: 1.8, perform: {
                                    self.longPressedTrack = track
                                    self.showAlertOnLongPress = true
                                })
                                .background(Color(UIColor.systemBackground))
                                .onTapGesture {
                                    withAnimation {
                                        playerManager.showMusicPlayer(tracks: [track])
                                    }
                                }
                                .onLongPressGesture(minimumDuration: 1.8, perform: {
                                    self.longPressedTrack = track
                                    self.showAlertOnLongPress = true
                                })
                                .alert(isPresented: $showAlertOnLongPress) {
                                    alertOnLongPress()
                                }.sheet(isPresented: $showPlaylistModelView) {
                                    PlaylistModalView(showModalView: $showPlaylistModelView, trackID: longPressedTrack!.id)
                                }
                            } else {
                                Image_PlayerButton_View(imageURL: model.imageURL, tracks: model.tracks)
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
    
    private func alertOnLongPress() -> Alert {
        if isOwner {
            return Alert(title: Text("\(longPressedTrack!.name)をプレイリストから削除しますか？"),
                         primaryButton: Alert.Button.destructive(Text("はい"), action: {
                            viewModel.removeTrackFromPlaylist(playlistID: playlistID, trackID: longPressedTrack!.id)
                         }),
                         secondaryButton: Alert.Button.cancel(Text("いいえ"))
            )
        } else {
            return Alert(title: Text("\(longPressedTrack!.name)をプレイリストに追加しますか？"),
                         primaryButton: Alert.Button.default(Text("はい"), action: {
                            self.showPlaylistModelView = true
                         }),
                         secondaryButton: Alert.Button.cancel(Text("いいえ"))
            )
        }
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlaylistDetailView(
                playlistID: "1", isOwner: false
            )
            .environment(\.colorScheme, .light)
            .previewDisplayName("light")
            
            PlaylistDetailView(playlistID: "2", isOwner: false)
                .environment(\.colorScheme, .dark)
                .previewDisplayName("dark")
            PlaylistDetailView(playlistID: "2", isOwner: false)
                .environment(\.locale, Locale(identifier: "en"))
                .previewDisplayName("English")
            
        }
    }
}
