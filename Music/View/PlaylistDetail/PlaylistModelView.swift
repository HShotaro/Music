//
//  PlaylistModelView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/04.
//

import SwiftUI

struct PlaylistModelView: View {
    let trackID: String
    var body: some View {
        Text("sss")
    }
}

struct PlaylistModelView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistModelView(trackID: AudioTrackModel.mock(1).id)
    }
}
