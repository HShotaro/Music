//
//  MusicApp.swift
//  Music
//
//  Created by 平野翔太郎 on 2021/08/01.
//

import SwiftUI
import Combine

@main
struct MusicApp: App {
    init() {
        UINavigationBar.appearance().backgroundColor = Color.primaryUIColor
        UINavigationBar.appearance().tintColor = UIColor.label
    }
    @EnvironmentObject var authManager: AuthManager
    
    var body: some Scene {
        WindowGroup {
            ContentView(authManager: _authManager)
                .environmentObject(AuthManager.shared)
                .environmentObject(MusicPlayerManager.shared)
        }
    }
}
