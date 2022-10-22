//
//  LibraryView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/24.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var playerManager: MusicPlayerManager
    @State var path: [SMPageDestination] = []
    @State private var selectedIndex: Int = 0
    @State private var offset: CGFloat = 0
    @Binding var didSelectLibraryTabTwice: Bool
    
    enum Tab: String, CaseIterable {
        case playlist = "Playlist"
        case album = "Album"
    }
    
    var body: some View {
        SMNavigationView(navigationTitle: "Library", navigationBarHidden: true, path: $path) {
            VStack(spacing: 0) {
                SelectorView(selectedIndex: $selectedIndex, offset: $offset, items: Tab.allCases.map { $0.rawValue })
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(Tab.allCases, id: \.self) { tab in
                                switch tab {
                                case .playlist:
                                    LibraryPlaylistsView(currentTabIndex: $selectedIndex, path: $path, didSelectLibraryTabTwice: $didSelectLibraryTabTwice).frame(width: geometry.size.width, height: geometry.size.height)
                                case .album:
                                    LibraryAlbumListView(currentTabIndex: $selectedIndex, path: $path, didSelectLibraryTabTwice: $didSelectLibraryTabTwice).frame(width: geometry.size.width, height: geometry.size.height)
                                }
                            }
                        }
                    }
                    .content.offset(x: self.offset)
                    .frame(width: geometry.size.width, alignment: .leading)
                    .highPriorityGesture(DragGesture()
                                .onChanged({ value in
                                    self.offset = value.translation.width - geometry.size.width * CGFloat(self.selectedIndex)
                                })
                                .onEnded({ value in
                                    let scrollThreshold = geometry.size.width / 2
                                    if value.predictedEndTranslation.width < -scrollThreshold {
                                        self.selectedIndex = min(self.selectedIndex + 1, Tab.allCases.endIndex - 1)
                                    } else if value.predictedEndTranslation.width > scrollThreshold {
                                        self.selectedIndex = max(self.selectedIndex - 1, 0)
                                    }
                                    
                                    withAnimation {
                                        self.offset = -geometry.size.width * CGFloat(self.selectedIndex)
                                    }
                                })
                    )
                }
                Spacer(minLength: playerManager.currentTrack != nil ? MusicPlayerView.height : 0)
            }
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    @State static var scrollTopTop = false
    static var previews: some View {
        LibraryView(didSelectLibraryTabTwice: $scrollTopTop)
    }
}
