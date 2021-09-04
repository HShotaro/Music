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
    @State private var tappedTwice: Bool = false
    @State private var didSelectHomeTabTwice = false
    @State private var didSelectSearchTabTwice = false
    @State private var didSelectLibraryTabTwice = false
    
    @State private var expand = false
    @Namespace var animation
    
    var body: some View {
        if authManager.isSignIn {
            let tabViewBinding =  Binding<Tab>(
                get: {
                    self.selection
                }, set: { tab in
                    if tab == self.selection {
                        tappedTwice = true
                    }
                    self.selection = tab
                })
            
            
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
                TabView(selection: tabViewBinding) {
                    HomeView(didSelectHomeTabTwice: $didSelectHomeTabTwice)
                    .tabItem {
                        Label(
                            title: { Text("Home") },
                            icon: { Image(systemName: "house")
                            }
                        ).accessibility(label: Text("Home_TabItem"))
                    }.tag(Tab.home)
                        .onChange(of: tappedTwice, perform: { isTwice in
                            if isTwice {
                                didSelectHomeTabTwice = true
                                tappedTwice = false
                            }
                        })
                    
                    SearchView(didSelectSearchTabTwice: $didSelectSearchTabTwice)
                    .tabItem {
                        Label(
                            title: { Text("Search") },
                            icon: { Image(systemName: "magnifyingglass")
                            }
                        ).accessibility(label: Text("Search_TabItem"))
                    }.tag(Tab.search)
                        .onChange(of: tappedTwice, perform: { isTwice in
                            if isTwice {
                                self.didSelectSearchTabTwice = true
                                tappedTwice = false
                            }
                        })
                    
                    LibraryView(didSelectLibraryTabTwice: $didSelectLibraryTabTwice)
                    .tabItem {
                        Label(
                            title: { Text("Library") },
                            icon: { Image(systemName: "music.note.list")
                            }
                        ).accessibility(label: Text("Library_TabItem"))
                    }.tag(Tab.library)
                        .onChange(of: tappedTwice, perform: { isTwice in
                            if isTwice {
                                self.didSelectLibraryTabTwice = true
                                tappedTwice = false
                            }
                        })
                    
                }.accentColor(Color.primaryColor)
                MusicPlayerView(animation: animation)
                    .opacity(playerManager.currentTrack != nil ? 1.0 : 0.0)
            }
        } else {
            NavigationView {
                WelcomeView()
                    .navigationBarHidden(true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AuthManager.shared)
    }
}
