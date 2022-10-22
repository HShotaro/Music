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
    
    init(navigationTitle: String, navigationBarHidden: Bool = false, @ViewBuilder _ content: () -> Content) {
        self.navigationTitle = navigationTitle
        self.navigationBarHidden = navigationBarHidden
        self.content = content()
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                content
                    .toolbarBackground(
                        Color.primaryColor,
                        for: .navigationBar)
                    .toolbarBackground(navigationBarHidden ? .hidden : .visible, for: .navigationBar)
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .navigationTitle(navigationTitle)
                    .toolbar(navigationBarHidden ? .hidden : .visible)
                
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
