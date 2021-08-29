//
//  DefaultButtonStyle.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import SwiftUI

struct StaticBackgroundButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        StaticBackgroundButton(configuration:configuration)
        }
    
    struct StaticBackgroundButton: View {
            @Environment(\.isEnabled) var isEnabled
            let configuration: StaticBackgroundButtonStyle.Configuration
            var body: some View {
                configuration.label
                    .background(Color(UIColor.systemBackground))
                    .foregroundColor(Color(UIColor.systemBackground))
                    .opacity(configuration.isPressed ? 0.2 : 1.0)
            }
        }
}
