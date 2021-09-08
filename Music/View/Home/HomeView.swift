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
    
    //NavigationLink(destination: destinationView, isActive: $isPushActive)の引数destinationはisPushActiveがtrueになる直前にbodyを更新して値を代入する必要がある。
    @State var destinationView: AnyView? = nil
    // プッシュ遷移したらtrue、ポップしたらfalse
    @State var isPushActive = false
    
    @Binding var didSelectHomeTabTwice: Bool
    static let topID = "HomeView_TopID"
    
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
                    ScrollViewReader { proxy in
                        ScrollView(.vertical) {
                            Section(header: LazyPinnedView(title: "NewReleasedAlbums", color: Color(.systemBackground)).id(HomeView.topID)) {
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
                        }.onChange(of: didSelectHomeTabTwice, perform: { scrollTopTop in
                            if scrollTopTop {
                                if isPushActive {
                                    withAnimation {
                                        self.isPushActive = false
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
