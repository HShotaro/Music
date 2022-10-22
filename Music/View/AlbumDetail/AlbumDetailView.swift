//
//  AlbumDetailView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/02.
//

import SwiftUI

struct AlbumDetailView: View {
    enum Stateful: Equatable {
        case idle
        case loading
        case failed(Error)
        case loaded(AlbumDetailModel)
        case addedAlbumToLibrary(AlbumDetailModel)
        
        static func == (lhs: Stateful, rhs: Stateful) -> Bool {
            switch (lhs, rhs) {
            case (idle, idle):
                return true
            case (loading, loading):
                return true
            case (let .failed(el), let .failed(er)):
                return el.localizedDescription == er.localizedDescription
            case (let .loaded(vl), let .loaded(vr)):
                return vl == vr
            case (.addedAlbumToLibrary, .addedAlbumToLibrary):
                return true
            default:
                return false
            }
        }
    }
    @StateObject private var viewModel = AlbumDetailViewModel()
    @EnvironmentObject var playerManager: MusicPlayerManager
    @State var showAlertOnLongPress = false
    @State var showPlaylistModelView = false
    @State var showConfirmToAddAlbumAlert = false
    @State var showSucceedToAddAlbumAlert = false
    let album: AlbumModel
    
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
                            viewModel.onRetryButtonTapped(album: album)
                        }, label: {
                            Text("リトライ")
                                .fontWeight(.bold)
                        }
                    )
                    .padding(.top, 8)
                }
            case let .loaded(model), let .addedAlbumToLibrary(model):
                EmptyView()
                    .alert(isPresented: $showSucceedToAddAlbumAlert, content: {
                        Alert(title: Text("ライブラリに\(album.name)を追加しました"), dismissButton: Alert.Button.default(Text("閉じる")))
                    })
                if model.tracks.isEmpty {
                    Text("このアルバムには曲がありません。")
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
                                .allowsHitTesting(false)
                                .background(Color(UIColor.secondarySystemGroupedBackground))
                                .onTapGesture {
                                    withAnimation {
                                        playerManager.showMusicPlayer(tracks: [track])
                                    }
                                }
                                .onLongPressGesture(minimumDuration: 1.8, perform: {
                                    self.viewModel.longPressedTrack = track
                                    self.showAlertOnLongPress = true
                                })
                            } else {
                                Image_PlayerButton_View(imageURL: model.imageURL, tracks: model.tracks)
                                    .buttonStyle(StaticBackgroundButtonStyle())
                            }
                        }
                    }.alert(isPresented: $showAlertOnLongPress) {
                        Alert(title: Text("\(viewModel.longPressedTrack!.name)をプレイリストに追加しますか？"),
                                     primaryButton: Alert.Button.default(Text("はい"), action: {
                                        self.showPlaylistModelView = true
                                     }),
                                     secondaryButton: Alert.Button.cancel(Text("いいえ"))
                        )
                    }.sheet(isPresented: $showPlaylistModelView) {
                        PlaylistModalView(showModalView: $showPlaylistModelView, trackID: viewModel.longPressedTrack!.id)
                    }
                    if playerManager.currentTrack != nil {
                        Spacer(minLength: MusicPlayerView.height)
                    }
                }
            }
        }.onAppear {
            viewModel.onAppear(album: album)
        }.onChange(of: viewModel.model, perform: { model in
            guard case .addedAlbumToLibrary = model else { return }
            self.showSucceedToAddAlbumAlert = true
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    self.showConfirmToAddAlbumAlert = true
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                }).alert(isPresented: $showConfirmToAddAlbumAlert) {
                    Alert(title: Text("\(album.name)をライブラリに追加しますか？"),
                          primaryButton: Alert.Button.default(Text("はい"), action: {
                            viewModel.addAlbumToLibrary(album: album)
                          }),
                          secondaryButton: Alert.Button.cancel(Text("いいえ"))
                    )
                }
            }
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
