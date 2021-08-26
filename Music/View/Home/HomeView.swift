//
//  HomeView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/24.
//

import SwiftUI
import Combine

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
    static let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 10, alignment: .center), count: 2)
    var body: some View {
        NavigationView {
            Group{
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
                        ScrollView {
                            LazyVGrid(columns: HomeView.columns, spacing: 10) {
                                ForEach(model.playlists, id: \.self.id) { playist in
                                    NavigationLink (
                                        destination: PlaylistView(playlist: playist),
                                        label: {
                                            GridItemLayout1(
                                                titleName: playist.name,
                                                subTitleName: playist.creatorName,
                                                imageURL: playist.imageURL
                                            )
                                            
                                            .background(Color.pink)
                                        }
                                        
                                    )
                                }
                            }.font(.largeTitle)
                            .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
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
            HomeView(
                viewModel: HomeViewModel(
                    repository:
                        HomeMockRepository(
                            playlists: [
                                PlayListModel.mock(1),
                                PlayListModel.mock(2),
                                PlayListModel.mock(3),
                                PlayListModel.mock(4),
                                PlayListModel.mock(5)
                            ]
                        )
                )
            )
            .previewDisplayName("Default")
            
            HomeView(
                viewModel: HomeViewModel(
                    repository:
                        HomeMockRepository(
                            playlists: []
                        )
                )
            )
            .previewDisplayName("Empty")
            
            HomeView(
                viewModel: HomeViewModel(
                    repository:
                        HomeMockRepository(
                            playlists: [],
                            error: DummyError()
                        )
                )
            )
            .previewDisplayName("Error")
        }
    }
}
