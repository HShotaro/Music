//
//  NavigationBarModifier.swift
//  Music
//
//  Created by Shotaro Hirano on 2022/10/22.
//

import SwiftUI

struct SMNavigationBarModifier: ViewModifier {
    let backgroundColor: UIColor

    init(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        if #available(iOS 16.0, *) {
            
        } else {
            let coloredAppearance = UINavigationBarAppearance()
            coloredAppearance.configureWithTransparentBackground()
            coloredAppearance.backgroundColor = backgroundColor
            coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

            UINavigationBar.appearance().standardAppearance = coloredAppearance
            UINavigationBar.appearance().compactAppearance = coloredAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
            UINavigationBar.appearance().tintColor = .white
        }
        
    }
    
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .toolbarBackground(
                    Color(uiColor: backgroundColor),
                    for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
        } else {
            content
        }
    }
}

extension View {
    func navigationBarColor(_ backgroundColor: UIColor) -> some View {
        modifier(SMNavigationBarModifier(backgroundColor: backgroundColor))
    }
}
