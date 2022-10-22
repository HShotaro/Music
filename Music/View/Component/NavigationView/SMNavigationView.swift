//
//  SMNavigationBar.swift
//  Music
//
//  Created by Shotaro Hirano on 2022/10/22.
//

import SwiftUI

struct SMNavigationView<Content: View>: View {
    let navigationTitle: String
    let navigationBarHidden: Bool
    let content: Content
    let path: Binding<[SMPageDestination]>
    
    init(navigationTitle: String, navigationBarHidden: Bool = false, path: Binding<[SMPageDestination]>, @ViewBuilder _ content: () -> Content) {
        self.navigationTitle = navigationTitle
        self.navigationBarHidden = navigationBarHidden
        self.path = path
        self.content = content()
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack(path: path) {
                content
                    .toolbarBackground(
                        Color.primaryColor,
                        for: .navigationBar)
                    .toolbarBackground(navigationBarHidden ? .hidden : .visible, for: .navigationBar)
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .navigationTitle(navigationTitle)
                    .toolbar(navigationBarHidden ? .hidden : .visible)
                    .navigationDestination(for: SMPageDestination.self) { page in
                        switch page {
                        case .mypage:
                            MypageView()
                        case .albumDetail(let album):
                            AlbumDetailView(album: album)
                        case .playlistDetail(let playlistID, let isOwner):
                            PlaylistDetailView(playlistID: playlistID, isOwner: isOwner)
                        case .artistDetail(let artistID):
                            ArtistDetailView(artistID: artistID)
                        case .authView:
                            AuthView()
                        }
                    }
                
            }
        } else {
            NavigationView {
                content
                    .navigationTitle(navigationTitle)
                    .navigationBarHidden(navigationBarHidden)    
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
