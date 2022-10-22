//
//  LibraryPlaylistView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import SwiftUI

struct LibraryPlaylistsView: View {
    @StateObject private var viewModel = LibraryPlaylistsViewModel()
    @Binding var currentTabIndex: Int
    @Binding var path: [SMPageDestination]
    @Binding var didSelectLibraryTabTwice: Bool
    static let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 10, alignment: .center), count: 2)
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
                            viewModel.onRetryButtonTapped()
                        }, label: {
                            Text("リトライ")
                                .fontWeight(.bold)
                        }
                    )
                    .padding(.top, 8)
                }
            case let .loaded(model):
                ScrollViewReader { proxy in
                    ScrollView(.vertical) {
                        LazyVGrid(columns: LibraryPlaylistsView.columns, spacing: 10) {
                                ForEach(model.playlists, id: \.self.id) { playlist in
                                    if #available(iOS 16.0, *) {
                                        GridItem_Title_SubTitle_Image_View(
                                            titleName: playlist.name,
                                            subTitleName: playlist.creatorName,
                                            imageURL: playlist.imageURL
                                        ).onTapGesture {
                                            path.append(.playlistDetail(playlistID: playlist.id, isOwner: true))
                                        }.id(playlist.id)
                                    } else {
                                        NavigationLink {
                                            PlaylistDetailView(playlistID: playlist.id, isOwner: true)
                                        } label: {
                                            GridItem_Title_SubTitle_Image_View(
                                                titleName: playlist.name,
                                                subTitleName: playlist.creatorName,
                                                imageURL: playlist.imageURL
                                            ).id(playlist.id)
                                        }
                                    }
                                }
                        }.padding(.all, 15)
                    }.onChange(of: didSelectLibraryTabTwice, perform: { scrollTopTop in
                        if scrollTopTop {
                            if !path.isEmpty {
                                withAnimation {
                                    path.removeAll()
                                }
                                proxy.scrollTo(model.playlists.first?.id)
                            } else {
                                withAnimation {
                                    proxy.scrollTo(model.playlists.first?.id)
                                }
                            }
                            self.didSelectLibraryTabTwice = false
                        }
                    })
                }
                
            }
        }.onChange(of: currentTabIndex, perform: { index in
            if LibraryView.Tab.allCases[index] == .playlist {
                viewModel.onTabChanged()
            }
        })
    }
}

struct LibraryPlaylistsView_Previews: PreviewProvider {
    @State static var path: [SMPageDestination] = []
    @State static var currentTabIndex = 0
    @State static var scrollTopTop = false
    static var previews: some View {
        LibraryPlaylistsView(currentTabIndex: $currentTabIndex, path: $path, didSelectLibraryTabTwice: $scrollTopTop)
    }
}
