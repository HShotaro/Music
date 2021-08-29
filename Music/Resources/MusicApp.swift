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
    private var cancelables = Set<AnyCancellable>()
    init() {
        if AuthManager.shared.isSignIn {
            AuthManager.shared.refreshIfNeeded()
            .sink { _ in } receiveValue: { _ in }
            .store(in: &cancelables)
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
