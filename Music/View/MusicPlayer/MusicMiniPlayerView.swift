//
//  MusicMiniPlayerView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/01.
//

import SwiftUI

struct MusicMiniPlayerView: View {
    static let height: CGFloat = 80
    @EnvironmentObject var playerManager: MusicPlayerManager
    @State var image: UIImage = UIImage(systemName: "photo") ?? UIImage()
    
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 55, height: 55)
                    .cornerRadius(15)
                VStack(alignment: .leading, spacing: 5) {
                    Text(playerManager.currentTrack?.name ?? "")
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    Text(playerManager.currentTrack?.artist.name ?? "")
                        .font(.subheadline)
                        .lineLimit(1)
                }
                Spacer(minLength: 0)
                
                Button {
                    playerManager.playButtonSelected()
                } label: {
                    Image(systemName: playerManager.onPlaying ? "pause" : "play.fill")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                
                Button {
                    playerManager.nextButtonSelected()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal)
        }
        .onChange(of: playerManager.currentTrack, perform: { _ in
            DispatchQueue.global().async {
                if let url = playerManager.currentTrack?.album.imageURL {
                    downloadImageAsync(url: url) { image in
                        self.image = image ?? UIImage()
                    }
                }
            }
        })
        .frame(height: MusicMiniPlayerView.height)
        .background(
            VStack(spacing: 0) {
                BlurView()
                Divider()
            }
        )
        .offset(y: -48)
    }
}

struct MusicMiniPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        MusicMiniPlayerView()
            .environmentObject(MusicPlayerManager.shared)
    }
}
