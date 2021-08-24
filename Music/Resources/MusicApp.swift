//
//  MusicApp.swift
//  Music
//
//  Created by 平野翔太郎 on 2021/08/01.
//

import SwiftUI

@main
struct MusicApp: App {
    init() {
        if AuthManager.shared.isSignIn {
            AuthManager.shared.refreshIfNeeded(completion: nil)
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
