//
//  LibraryAlbumView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import SwiftUI

struct LibraryAlbumListView: View {
    @StateObject private var viewModel = LibraryAlbumListViewModel()
    @State var longPressedAlbum: AlbumModel?
    @State var showAlert = false
    @Binding var currentTabIndex: Int
    @Binding var destinationView: AnyView?
    @Binding var isPushActive: Bool
    @Binding var scrollTopTop: Bool
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
                                    .onLongPressGesture(minimumDuration: 1.8, perform: {
                                        self.longPressedAlbum = album
                                        self.showAlert = true
                                    })
                                    .id(album.id)
                                    .alert(isPresented: $showAlert) {
                                        Alert(title: Text("\(longPressedAlbum!.name)をライブラリから削除しますか？"),
                                              primaryButton: Alert.Button.destructive(Text("はい"), action: {
                                            viewModel.deleteAlbumFromLibrary(album: longPressedAlbum!)
                                        }),
                                              secondaryButton: Alert.Button.cancel(Text("いいえ"))
                                        )
                                    }
                                }
                        }.padding(.all, 15)
                    }.onChange(of: scrollTopTop, perform: { scrollTopTop in
                        if scrollTopTop {
                            withAnimation {
                                proxy.scrollTo(model.albumList.first?.id)
                            }
                            self.scrollTopTop = false
                        }
                    })
                }
            }
        }.onChange(of: currentTabIndex, perform: { index in
            if LibraryView.Tab.allCases[index] == .album {
                viewModel.onTabChanged()
            }
        })
    }}

struct LibraryAlbumView_Previews: PreviewProvider {
    @State static var anyView: AnyView? = nil
    @State static var isPushActive = false
    @State static var currentTabIndex = 1
    @State static var scrollTopTop = false
    static var previews: some View {
        LibraryAlbumListView(currentTabIndex: $currentTabIndex, destinationView: $anyView, isPushActive: $isPushActive, scrollTopTop: $scrollTopTop)
    }
}
