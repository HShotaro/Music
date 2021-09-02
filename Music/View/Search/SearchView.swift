//
//  SearchView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/24.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var playerManager: MusicPlayerManager
    @StateObject private var viewModel = SearchViewModel()
    @State var destinationView: AnyView? = nil
    @State var isPushActive = false
    @State var searchText = ""
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField("Artist, Track, Album, Playlist", text: $searchText) { isBegin in
                    
                } onCommit: {
                    viewModel.search(with: searchText)
                }
                .textFieldStyle(SearchTextFieldStyle())
                .padding(.horizontal, 17)
                switch viewModel.model {
                case .idle:
                    EmptyView()
                case .loading:
                    HStack {
                        Spacer(minLength: 0)
                        ProgressView("loading...")
                        Spacer(minLength: 0)
                    }
                case .failed(_):
                    VStack(alignment: .center) {
                        Group {
                            Image("default_icon")
                            Text("検索に失敗しました。")
                                .padding(.top, 4)
                        }
                        .foregroundColor(.black)
                        .opacity(0.4)
                        Button(
                            action: {
                                viewModel.onRetryButtonTapped(with: searchText)
                            }, label: {
                                Text("リトライ")
                                    .fontWeight(.bold)
                            }
                        )
                        .padding(.top, 8)
                    }
                case let .loaded(model):
                    NavigationLink(destination: destinationView, isActive: $isPushActive) {
                        EmptyView()
                    }.hidden()
                    ScrollView(.vertical) {
                        Section(header: Listitem_Title_View(title: "Artist", font: .headline, fontWight: .bold)) {
                            ForEach(model.artists, id: \.self.id) { artist in
                                Button {
                                    destinationView = AnyView(ArtistDetailView(artistID: artist.id))
                                    isPushActive = true
                                } label: {
                                    Listitem_Title_View(title: artist.name, font: .caption, fontWight: .regular)
                                }.frame(width: UIScreen.main.bounds.width, height: 30)
                            }
                        }.multilineTextAlignment(.leading)
                        Section(header: Listitem_Title_View(title: "Track", font: .headline, fontWight: .bold)) {
                            ForEach(model.tracks, id: \.self.id) { track in
                                Button {
                                    playerManager.showMusicPlayer(tracks: [track])
                                } label: {
                                    Listitem_Title_View(title: track.name, font: .caption, fontWight: .regular)
                                }.frame(width: UIScreen.main.bounds.width, height: 30)
                            }
                        }.multilineTextAlignment(.leading)
                        Section(header: Listitem_Title_View(title: "Album", font: .headline, fontWight: .bold)) {
                            ForEach(model.albums, id: \.self.id) { album in
                                Button {
                                    destinationView = AnyView(AlbumDetailView(album: album))
                                    isPushActive = true
                                } label: {
                                    Listitem_Title_View(title: album.name, font: .caption, fontWight: .regular)
                                }.frame(width: UIScreen.main.bounds.width, height: 30)
                            }
                        }.multilineTextAlignment(.leading)
                        Section(header: Listitem_Title_View(title: "Playlist", font: .headline, fontWight: .bold)) {
                            ForEach(model.playlists, id: \.self.id) { playlist in
                                Button {
                                    destinationView = AnyView(PlaylistDetailView(playlistID: playlist.id))
                                    isPushActive = true
                                } label: {
                                    Listitem_Title_View(title: playlist.name, font: .caption, fontWight: .regular)
                                }.frame(width: UIScreen.main.bounds.width, height: 30)
                            }
                        }.multilineTextAlignment(.leading)
                    }.padding(.vertical, 20)
                }
                Spacer(minLength: 0)
            }
            .navigationTitle("Search")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
