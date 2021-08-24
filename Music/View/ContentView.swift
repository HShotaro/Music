//
//  ContentView.swift
//  Music
//
//  Created by 平野翔太郎 on 2021/08/01.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var authManager = AuthManager.shared
    var body: some View {
        if AuthManager.shared.isSignIn {
            TabView {
                NavigationView {
                    HomeView()
                        .navigationTitle("Home")
                }
                .tabItem {
                    Label(
                        title: { Text(/*@START_MENU_TOKEN@*/"Home"/*@END_MENU_TOKEN@*/) },
                        icon: { Image(systemName: "house")
                        }
                    )
                }
                .tag(0)
                NavigationView {
                    SearchView()
                        .navigationTitle("Search")
                }
                
                .tabItem {
                    Label(
                        title: { Text(/*@START_MENU_TOKEN@*/"Search"/*@END_MENU_TOKEN@*/) },
                        icon: { Image(systemName: "magnifyingglass")
                        }
                    )
                }
                .tag(1)
                NavigationView {
                    LibraryView()
                        .navigationTitle("Library")
                }
                
                .tabItem {
                    Label(
                        title: { Text(/*@START_MENU_TOKEN@*/"Library"/*@END_MENU_TOKEN@*/) },
                        icon: { Image(systemName: "music.note.list")
                        }
                    )
                }
                .tag(2)
            }.accentColor(/*@START_MENU_TOKEN@*/.yellow/*@END_MENU_TOKEN@*/)
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
        ContentView()
    }
}
