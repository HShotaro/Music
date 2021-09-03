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
    @Binding var destinationView: AnyView?
    @Binding var isPushActive: Bool
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
                ScrollView(.vertical) {
                    LazyVGrid(columns: LibraryPlaylistsView.columns, spacing: 10) {
                            ForEach(model.playlists, id: \.self.id) { playlist in
                                GridItem_Title_SubTitle_Image_View(
                                    titleName: playlist.name,
                                    subTitleName: playlist.creatorName,
                                    imageURL: playlist.imageURL
                                ).onTapGesture {
                                    destinationView = AnyView(PlaylistDetailView(playlistID: playlist.id))
                                    isPushActive = true
                                }
                                
                            }
                    }.padding(.all, 15)
                }
            }
        }.onChange(of: currentTabIndex, perform: { index in
            if LibraryView.Tab.allCases[index] == .playlist {
                viewModel.onAppear()
            }
        })
    }
}

struct LibraryPlaylistsView_Previews: PreviewProvider {
    @State static var anyView: AnyView? = nil
    @State static var isPushActive = false
    @State static var currentTabIndex = 0
    static var previews: some View {
        LibraryPlaylistsView(currentTabIndex: $currentTabIndex, destinationView: $anyView, isPushActive: $isPushActive)
    }
}
