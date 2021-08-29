//
//  MusicPlayerView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import SwiftUI

struct MusicPlayerView: View {
    @StateObject private var viewModel: MusicPlayerViewModel
    
    init(audioTracks: [AudioTrackModel], viewModel: MusicPlayerViewModel = MusicPlayerViewModel()) {
        viewModel.audioTracks = audioTracks.shuffled()
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        Text(viewModel.currentTrack?.name ?? "")
    }
}

struct MusicPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerView(audioTracks: [AudioTrackModel.mock(1), AudioTrackModel.mock(2), AudioTrackModel.mock(3)])
    }
}
