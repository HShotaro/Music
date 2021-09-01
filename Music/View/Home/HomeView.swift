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
    @State var destinationView: AnyView? = nil
    @State var isPushActive = false
    
    static let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 10, alignment: .center), count: 2)
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.model {
                case .idle, .loading:
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
                    if model.playlists.isEmpty {
                        Text("最新のプレイリストがありません。")
                            .fontWeight(.bold)
                    } else {
                        NavigationLink(destination: destinationView, isActive: $isPushActive) {
                            EmptyView()
                        }.hidden()
                        ScrollView {
                            LazyVGrid(columns: HomeView.columns, spacing: 10) {
                                ForEach(model.playlists, id: \.self.id) { playlist in
                                    Button {
                                        destinationView = AnyView(PlaylistDetailView(playlistID: playlist.id))
                                        isPushActive = true
                                    } label: {
                                        GridItemLayout1View(
                                            titleName: playlist.name,
                                            subTitleName: playlist.creatorName,
                                            imageURL: playlist.imageURL
                                        )
                                    }
                                }
                            }.font(.largeTitle)
                            .padding(EdgeInsets(top: 15, leading: 15, bottom: 15 + MusicMiniPlayerView.height, trailing: 15))
                        }
                    }
                }
            }
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
