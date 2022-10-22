//
//  HomeView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/24.
//

import SwiftUI
import Combine

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State var path: [SMPageDestination] = []
    
    @Binding var didSelectHomeTabTwice: Bool
    static let topID = "HomeView_TopID"
    
    static let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 10, alignment: .center), count: 2)
    var body: some View {
        SMNavigationView(navigationTitle: "Home", path: $path) {
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
                                viewModel.onRetryButtonTapped()
                            }, label: {
                                Text("リトライ")
                                    .fontWeight(.bold)
                            }
                        )
                        .padding(.top, 8)
                    }
                case let .loaded(model):
                    GeometryReader { geometry in
                        ScrollViewReader { proxy in
                            ScrollView(.vertical) {
                                Section(header: LazyPinnedView(title: "NewReleasedAlbums", color: Color(.systemBackground)).id(HomeView.topID)) {
                                    ScrollView(.horizontal) {
                                        HStack(spacing: 10) {
                                            ForEach(model.albums, id: \.self.id) { album in
                                                if #available(iOS 16.0, *) {
                                                    Button {
                                                        path.append(.albumDetail(album: album))
                                                    } label: {
                                                        GridItem_Title_SubTitle_Image_View(titleName: album.name, subTitleName: album.artist.name, imageURL: album.imageURL)
                                                    }.frame(width: 120, height: 180)
                                                } else {
                                                    NavigationLink {
                                                        AlbumDetailView(album: album)
                                                    } label: {
                                                        GridItem_Title_SubTitle_Image_View(titleName: album.name, subTitleName: album.artist.name, imageURL: album.imageURL)
                                                            .frame(width: 120, height: 180)
                                                    }
                                                }
                                            }
                                        }
                                    }.frame(width: geometry.size.width, height: 180)
                                }
                                LazyVGrid(columns: HomeView.columns, spacing: 10) {
                                    Section(header: LazyPinnedView(title: "FeaturedPlaylist", color: Color(.systemBackground))) {
                                        ForEach(model.playlists, id: \.self.id) { playlist in
                                            if #available(iOS 16.0, *) {
                                                Button {
                                                    path.append(.playlistDetail(playlistID: playlist.id, isOwner: false))
                                                } label: {
                                                    GridItem_Title_SubTitle_Image_View(
                                                        titleName: playlist.name,
                                                        subTitleName: playlist.creatorName,
                                                        imageURL: playlist.imageURL
                                                    )
                                                }
                                            } else {
                                                NavigationLink {
                                                    PlaylistDetailView(playlistID: playlist.id, isOwner: false)
                                                } label: {
                                                    GridItem_Title_SubTitle_Image_View(
                                                        titleName: playlist.name,
                                                        subTitleName: playlist.creatorName,
                                                        imageURL: playlist.imageURL
                                                    )
                                                }
                                            }
                                        }
                                    }
                                }.font(.largeTitle)
                                    .padding(EdgeInsets(top: 15, leading: 15, bottom: 15 + MusicPlayerView.height, trailing: 15))
                            }.onChange(of: didSelectHomeTabTwice, perform: { scrollTopTop in
                                if scrollTopTop {
                                    if !path.isEmpty {
                                        withAnimation {
                                            path.removeAll()
                                        }
                                        proxy.scrollTo(HomeView.topID)
                                    } else {
                                        withAnimation {
                                            proxy.scrollTo(HomeView.topID)
                                        }
                                    }
                                    self.didSelectHomeTabTwice = false
                                }
                            })
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    if #available(iOS 16.0, *) {
                        Button(action: {
                            path.append(.mypage)
                        }, label: {
                            Image(systemName: "gear")
                        })
                    } else {
                        NavigationLink {
                            MypageView()
                        } label: {
                            Image(systemName: "gear")
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    @State static var didSelectHomeTabTwice = false
    static var previews: some View {
        Group {
            HomeView(didSelectHomeTabTwice: $didSelectHomeTabTwice)
                .environment(\.colorScheme, .light)
                .previewDisplayName("light")
            
            HomeView(didSelectHomeTabTwice: $didSelectHomeTabTwice)
                .environment(\.colorScheme, .dark)
                .previewDisplayName("dark")
            HomeView(didSelectHomeTabTwice: $didSelectHomeTabTwice)
                .environment(\.locale, Locale(identifier: "en"))
                .previewDisplayName("English")
        }
    }
}
