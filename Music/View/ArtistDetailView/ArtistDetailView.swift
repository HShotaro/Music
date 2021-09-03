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
    @State var longPressedTrack: AudioTrackModel?
    @State var showAlertOnLongPress = false
    @State var showPlaylistModelView = false
    
    let artistID: String

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
                                    Alert(title: Text("\(longPressedTrack!.name)をプレイリストに追加しますか？"),
                                                 primaryButton: Alert.Button.default(Text("はい"), action: {
                                                    self.showPlaylistModelView = true
                                                 }),
                                                 secondaryButton: Alert.Button.cancel(Text("いいえ"))
                                    )
                                }.sheet(isPresented: $showPlaylistModelView) {
                                    PlaylistModalView(showModalView: $showPlaylistModelView, trackID: longPressedTrack!.id)
                                }
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
