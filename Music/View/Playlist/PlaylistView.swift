//
//  PlaylistView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/25.
//

import SwiftUI

struct PlaylistView: View {
    let playlist: PlayListModel
    var body: some View {
        Text(playlist.name)
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView(playlist: PlayListModel.mock(1))
    }
}
