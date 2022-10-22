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
    @State var path: [SMPageDestination] = []
    @State var searchText = ""
    @Binding var didSelectSearchTabTwice: Bool
    static let topID = "SearchView_TopID"
    var body: some View {
        SMNavigationView(navigationTitle: "Search", path: $path) {
            VStack(alignment: .leading, spacing: 0) {
                GeometryReader { geometry in
                    ScrollViewReader { proxy in
                        ScrollView(.vertical) {
                            Group {
                                TextField("Artist, Track, Album, Playlist", text: $searchText) { isBegin in
                                    
                                } onCommit: {
                                    viewModel.search(with: searchText)
                                }
                                .textFieldStyle(SearchTextFieldStyle())
                                .padding(.horizontal, 17)
                                .padding(.vertical, 10)
                                .id(SearchView.topID)
                            }.background(Color.primaryColor)
                            
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
                                    HStack {
                                        Spacer(minLength: 0)
                                        Image("default_icon")
                                        Text("検索に失敗しました。")
                                            .padding(.top, 4)
                                        Spacer(minLength: 0)
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
                                    Spacer(minLength: 10)
                                    Section(header: Listitem_Title_View(title: "Artist", font: .headline, fontWight: .bold)) {
                                        ForEach(model.artists, id: \.self.id) { artist in
                                            if #available(iOS 16.0, *) {
                                                Button {
                                                    path.append(.artistDetail(artistID: artist.id))
                                                } label: {
                                                    Listitem_Title_View(title: artist.name, font: .subheadline, fontWight: .regular)
                                                }.frame(width: geometry.size.width, height: 25)
                                            } else {
                                                NavigationLink {
                                                    ArtistDetailView(artistID: artist.id)
                                                } label: {
                                                    Listitem_Title_View(title: artist.name, font: .subheadline, fontWight: .regular)
                                                        .frame(width: geometry.size.width, height: 25)
                                                }
                                            }
                                        }
                                    }.multilineTextAlignment(.leading)
                                    Section(header: Listitem_Title_View(title: "Track", font: .headline, fontWight: .bold)) {
                                        ForEach(model.tracks, id: \.self.id) { track in
                                            Button {
                                                withAnimation(.spring()) {
                                                    playerManager.showMusicPlayer(tracks: [track])
                                                }
                                            } label: {
                                                Listitem_Title_View(title: track.name, font: .subheadline, fontWight: .regular)
                                            }.frame(width: geometry.size.width, height: 25)
                                        }
                                    }.multilineTextAlignment(.leading)
                                    Section(header: Listitem_Title_View(title: "Album", font: .headline, fontWight: .bold)) {
                                        ForEach(model.albums, id: \.self.id) { album in
                                            if #available(iOS 16.0, *) {
                                                Button {
                                                    path.append(.albumDetail(album: album))
                                                } label: {
                                                    Listitem_Title_View(title: album.name, font: .subheadline, fontWight: .regular)
                                                }.frame(width: geometry.size.width, height: 25)
                                            } else {
                                                NavigationLink {
                                                    AlbumDetailView(album: album)
                                                } label: {
                                                    Listitem_Title_View(title: album.name, font: .subheadline, fontWight: .regular)
                                                        .frame(width: geometry.size.width, height: 25)
                                                }
                                            }
                                        }
                                    }.multilineTextAlignment(.leading)
                                    Section(header: Listitem_Title_View(title: "Playlist", font: .headline, fontWight: .bold)) {
                                        ForEach(model.playlists, id: \.self.id) { playlist in
                                            if #available(iOS 16.0, *) {
                                                Button {
                                                    path.append(.playlistDetail(playlistID: playlist.id, isOwner: false))
                                                } label: {
                                                    Listitem_Title_View(title: playlist.name, font: .subheadline, fontWight: .regular)
                                                }.frame(width: geometry.size.width, height: 25)
                                            } else {
                                                NavigationLink {
                                                    PlaylistDetailView(playlistID: playlist.id, isOwner: false)
                                                } label: {
                                                    Listitem_Title_View(title: playlist.name, font: .subheadline, fontWight: .regular)
                                                        .frame(width: geometry.size.width, height: 25)
                                                }
                                            }
                                        }
                                    }.multilineTextAlignment(.leading)
                            }
                            Spacer(minLength: playerManager.currentTrack != nil ? MusicPlayerView.height : 0)
                        }.onChange(of: didSelectSearchTabTwice, perform: { scrollTopTop in
                            if scrollTopTop {
                                if !path.isEmpty {
                                    withAnimation {
                                        path.removeAll()
                                    }
                                    proxy.scrollTo(SearchView.topID)
                                } else {
                                    withAnimation {
                                        proxy.scrollTo(SearchView.topID)
                                    }
                                }
                                self.didSelectSearchTabTwice = false
                            }
                        })
                    }
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    @State static var didSelectSearchTabTwice = false
    static var previews: some View {
        SearchView(didSelectSearchTabTwice: $didSelectSearchTabTwice)
    }
}
