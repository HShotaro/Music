//
//  LibraryView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/24.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var playerManager: MusicPlayerManager
    @State var destinationView: AnyView? = nil
    @State var isPushActive = false
    @State private var selectedIndex: Int = 0
    @State private var offset: CGFloat = 0
    
    enum Tab: String, CaseIterable {
        case playlist = "Playlist"
        case album = "Album"
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                NavigationLink(destination: destinationView, isActive: $isPushActive) {
                    EmptyView()
                }.hidden()
                ToggleView(selectedIndex: $selectedIndex, offset: $offset, items: Tab.allCases.map { $0.rawValue })
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(Tab.allCases, id: \.self) { tab in
                                switch tab {
                                case .playlist:
                                    LibraryPlaylistsView(destinationView: $destinationView, isPushActive: $isPushActive).frame(width: geometry.size.width, height: geometry.size.height)
                                case .album:
                                    LibraryAlbumListView(destinationView: $destinationView, isPushActive: $isPushActive).frame(width: geometry.size.width, height: geometry.size.height)
                                }
                            }
                        }
                    }
                    .content.offset(x: self.offset)
                    .frame(width: geometry.size.width, alignment: .leading)
                    .gesture(DragGesture()
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
                .navigationTitle("Library")
                Spacer(minLength: playerManager.currentTrack != nil ? MusicPlayerView.height : 0)
            }
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
