//
//  LibraryAlbumView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import SwiftUI

struct LibraryAlbumListView: View {
    @StateObject private var viewModel = LibraryAlbumListViewModel()
    @State var showAlert = false
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
                    LazyVGrid(columns: LibraryAlbumListView.columns, spacing: 10) {
                            ForEach(model.albumList, id: \.self.id) { album in
                                GridItem_Title_SubTitle_Image_View(
                                    titleName: album.name,
                                    subTitleName: album.artist.name,
                                    imageURL: album.imageURL
                                ).onTapGesture {
                                    destinationView = AnyView(AlbumDetailView(album: album))
                                    isPushActive = true
                                }
                                .onLongPressGesture(minimumDuration: 1.0, perform: {
                                    self.showAlert = true
                                })
                                .alert(isPresented: $showAlert) {
                                    Alert(title: Text("このアルバムをライブラリから削除しますか？"),
                                          primaryButton: Alert.Button.destructive(Text("はい"), action: {
                                        viewModel.deleteAlbumFromLibrary(album: album)
                                    }),
                                          secondaryButton: Alert.Button.cancel(Text("いいえ"))
                                    )
                                }
                            }
                    }.padding(.all, 15)
                }
            }
        }.onChange(of: currentTabIndex, perform: { index in
            if LibraryView.Tab.allCases[index] == .album {
                viewModel.onAppear()
            }
        })
    }}

struct LibraryAlbumView_Previews: PreviewProvider {
    @State static var anyView: AnyView? = nil
    @State static var isPushActive = false
    @State static var currentTabIndex = 0
    static var previews: some View {
        LibraryAlbumListView(currentTabIndex: $currentTabIndex, destinationView: $anyView, isPushActive: $isPushActive)
    }
}
