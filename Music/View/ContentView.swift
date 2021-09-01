//
//  ContentView.swift
//  Music
//
//  Created by 平野翔太郎 on 2021/08/01.
//

import SwiftUI
import Combine

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var playerManager: MusicPlayerManager
    
    enum Tab {
        case home
        case search
        case library
    }

    @State private var selection: Tab = .home
    var body: some View {
        if authManager.isSignIn {
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
                TabView(selection: $selection) {
                    HomeView()
                    .tabItem {
                        Label(
                            title: { Text(/*@START_MENU_TOKEN@*/"Home"/*@END_MENU_TOKEN@*/) },
                            icon: { Image(systemName: "house")
                            }
                        ).accessibility(label: Text("Home_TabItem"))
                    }
                        .tag(Tab.home)
                    SearchView()
                    .tabItem {
                        Label(
                            title: { Text(/*@START_MENU_TOKEN@*/"Search"/*@END_MENU_TOKEN@*/) },
                            icon: { Image(systemName: "magnifyingglass")
                            }
                        ).accessibility(label: Text("Search_TabItem"))
                    }
                        .tag(Tab.search)
                    LibraryView()
                    .tabItem {
                        Label(
                            title: { Text(/*@START_MENU_TOKEN@*/"Library"/*@END_MENU_TOKEN@*/) },
                            icon: { Image(systemName: "music.note.list")
                            }
                        ).accessibility(label: Text("Library_TabItem"))
                    }
                        .tag(Tab.library)
                }.accentColor(/*@START_MENU_TOKEN@*/.yellow/*@END_MENU_TOKEN@*/)
                MusicMiniPlayerView()
                    .opacity(playerManager.currentTrack != nil ? 1.0 : 0.0)
            }
        } else {
            NavigationView {
                WelcomeView()
                    .navigationTitle("Welcome Music")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AuthManager.shared)
    }
}
