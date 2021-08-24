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
                HomeView()
                    .tabItem {
                        Label(
                            title: { Text(/*@START_MENU_TOKEN@*/"Home"/*@END_MENU_TOKEN@*/) },
                            icon: { Image(systemName: "house")
                            }
                        )
                    }
                SearchView()
                    .tabItem {
                        Label(
                            title: { Text(/*@START_MENU_TOKEN@*/"Search"/*@END_MENU_TOKEN@*/) },
                            icon: { Image(systemName: "magnifyingglass")
                            }
                        )
                    }
                LibraryView()
                    .tabItem {
                        Label(
                            title: { Text(/*@START_MENU_TOKEN@*/"Library"/*@END_MENU_TOKEN@*/) },
                            icon: { Image(systemName: "music.note.list")
                            }
                        )
                    }
            }.accentColor(/*@START_MENU_TOKEN@*/.yellow/*@END_MENU_TOKEN@*/)
        } else {
            NavigationView {
                WelcomeView()
            }.navigationTitle("Welcome Music")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
