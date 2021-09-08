//
//  MusicPlayerButtonStyle.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/07.
//

import SwiftUI

struct MusicPlayerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        MusicPlayerButton(configuration:configuration)
        }
    
    struct MusicPlayerButton: View {
        @Environment(\.isEnabled) var isEnabled
        let configuration: MusicPlayerButtonStyle.Configuration
        var body: some View {
            configuration.label
                .foregroundColor(isEnabled ? Color.primary : Color(.systemGray))
                .opacity(configuration.isPressed ? 0.2 : 1.0)
        }
    }
}
