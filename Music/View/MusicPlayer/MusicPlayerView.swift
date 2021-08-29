//
//  MusicPlayerView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import SwiftUI

struct MusicPlayerView: View {
    @StateObject private var manager =  MusicPlayerManager.shared
    let audioTracks: [AudioTrackModel]
    init(audioTracks: [AudioTrackModel]) {
        self.audioTracks = audioTracks.filter{ $0.previewURL != nil }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            let currentImageURLBinding = Binding<URL?>(
                get: {
                    return manager.currentTrack?.album.imageURL
                },
                set: { _ in }
            )
            MusicPlayerImageView(imageURL: currentImageURLBinding)
            Text(manager.currentTrack?.name ?? "")
                .font(.headline)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .padding([.leading, .bottom, .trailing])
            Text(manager.currentTrack?.artist.name ?? "")
                .font(.subheadline)
                .multilineTextAlignment(.leading)
                .padding([.leading, .bottom, .trailing])
            HStack(alignment: .center, spacing: 50) {
                Button(action: {
                    manager.backButtonSelected()
                }, label: {
                    Image(systemName: "backward.fill")
                })
                .frame(width: 50, height: 50)
                Button(action: {
                    manager.playButtonSelected()
                }, label: {
                    Image(systemName: manager.onPlaying ? "pause" : "play.fill")
                })
                .frame(width: 50, height: 50)
                Button(action: {
                    manager.nextButtonSelected()
                }, label: {
                    Image(systemName: "forward.fill")
                })
                .frame(width: 50, height: 50)
            }
        }.onAppear {
            if !manager.audioTracks.isSameOf(audioTracks) {
                manager.audioTracks = audioTracks
            }
        }
    }
}

struct MusicPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerView(audioTracks: [AudioTrackModel.mock(1), AudioTrackModel.mock(2), AudioTrackModel.mock(3)])
    }
}
