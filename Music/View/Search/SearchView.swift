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
    @Binding var didSelectSearchTabTwice: Bool
    static let topID = "SearchView_TopID"
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                NavigationLink(destination: destinationView, isActive: $isPushActive) {
                    EmptyView()
                }.hidden()
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
                                        Button {
                                            destinationView = AnyView(ArtistDetailView(artistID: artist.id))
                                            isPushActive = true
                                        } label: {
                                            Listitem_Title_View(title: artist.name, font: .subheadline, fontWight: .regular)
                                        }.frame(width: UIScreen.main.bounds.width, height: 25)
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
                                        }.frame(width: UIScreen.main.bounds.width, height: 25)
                                    }
                                }.multilineTextAlignment(.leading)
                                Section(header: Listitem_Title_View(title: "Album", font: .headline, fontWight: .bold)) {
                                    ForEach(model.albums, id: \.self.id) { album in
                                        Button {
                                            destinationView = AnyView(AlbumDetailView(album: album))
                                            isPushActive = true
                                        } label: {
                                            Listitem_Title_View(title: album.name, font: .subheadline, fontWight: .regular)
                                        }.frame(width: UIScreen.main.bounds.width, height: 25)
                                    }
                                }.multilineTextAlignment(.leading)
                                Section(header: Listitem_Title_View(title: "Playlist", font: .headline, fontWight: .bold)) {
                                    ForEach(model.playlists, id: \.self.id) { playlist in
                                        Button {
                                            destinationView = AnyView(PlaylistDetailView(playlistID: playlist.id, isOwner: false))
                                            isPushActive = true
                                        } label: {
                                            Listitem_Title_View(title: playlist.name, font: .subheadline, fontWight: .regular)
                                        }.frame(width: UIScreen.main.bounds.width, height: 25)
                                    }
                                }.multilineTextAlignment(.leading)
                        }
                        Spacer(minLength: playerManager.currentTrack != nil ? MusicPlayerView.height : 0)
                    }.onChange(of: didSelectSearchTabTwice, perform: { scrollTopTop in
                        if scrollTopTop {
                            if isPushActive {
                                withAnimation {
                                    self.isPushActive = false
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
            .navigationTitle("Search")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SearchView_Previews: PreviewProvider {
    @State static var didSelectSearchTabTwice = false
    static var previews: some View {
        SearchView(didSelectSearchTabTwice: $didSelectSearchTabTwice)
    }
}
