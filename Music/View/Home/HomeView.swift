//
//  HomeView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/24.
//

import SwiftUI
import Combine

struct HomeView: View {
    // @StateObjectはbodyが最初に更新される直前に初期化され、onDisappear()のタイミングでdeinitされる。
    // HomeViewのinit()の中で@StateObjectを初期化してしまうと@StateObjectのメリットを捨ててしまうことになるのでやめるべきである。
    @StateObject private var viewModel = HomeViewModel()
    
    //@Stateの二つの変数destinationViewとisPushActiveを連続で変えた場合、bodyは一回のみ呼ばれる。また、destinationViewをviewModelで持とうとすると、bodyが更新されずページ遷移に失敗する。
    @State var destinationView: AnyView? = nil
    // プッシュ遷移後に、ポップするとfalseに戻る
    @State var isPushActive = false
    
    static let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 10, alignment: .center), count: 2)
    var body: some View {
        NavigationView {
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
                    NavigationLink(destination: destinationView, isActive: $isPushActive) {
                        EmptyView()
                    }.hidden()
                    ScrollView(.vertical) {
                        Section(header: LazyPinnedView(title: "NewReleasedAlbums", color: Color(.systemBackground))) {
                            ScrollView(.horizontal) {
                                HStack(spacing: 10) {
                                    ForEach(model.albums, id: \.self.id) { album in
                                        Button {
                                            destinationView = AnyView(AlbumDetailView(album: album))
                                            isPushActive = true
                                        } label: {
                                            GridItem_Title_SubTitle_Image_View(titleName: album.name, subTitleName: album.artist.name, imageURL: album.imageURL)
                                        }.frame(width: 120, height: 180)
                                    }
                                }
                            }.frame(width: UIScreen.main.bounds.width, height: 180)
                        }
                        LazyVGrid(columns: HomeView.columns, spacing: 10) {
                            Section(header: LazyPinnedView(title: "FeaturedPlaylist", color: Color(.systemBackground))) {
                                ForEach(model.playlists, id: \.self.id) { playlist in
                                    Button {
                                        destinationView = AnyView(PlaylistDetailView(playlistID: playlist.id, isOwner: false))
                                        isPushActive = true
                                    } label: {
                                        GridItem_Title_SubTitle_Image_View(
                                            titleName: playlist.name,
                                            subTitleName: playlist.creatorName,
                                            imageURL: playlist.imageURL
                                        )
                                    }
                                }
                            }
                        }.font(.largeTitle)
                        .padding(EdgeInsets(top: 15, leading: 15, bottom: 15 + MusicPlayerView.height, trailing: 15))
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                destinationView = AnyView(MypageView())
                isPushActive = true
            }, label: {
                Image(systemName: "gear")
            }))
            .navigationTitle("Home")
        }.onAppear {
            viewModel.onAppear()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .environment(\.colorScheme, .light)
                .previewDisplayName("light")
            
            HomeView()
                .environment(\.colorScheme, .dark)
                .previewDisplayName("dark")
            HomeView()
                .environment(\.locale, Locale(identifier: "en"))
                .previewDisplayName("English")
        }
    }
}
