//
//  MusicMiniPlayerView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/01.
//

import SwiftUI

struct MusicPlayerView: View {
    static let height: CGFloat = 80
    @EnvironmentObject var playerManager: MusicPlayerManager
    @State var showPlaylistModelView = false
    @State var image: UIImage = UIImage(systemName: "photo") ?? UIImage()
    @State var offset: CGFloat = 0
    var animation: Namespace.ID
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(spacing: 15) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: playerManager.expanding ? .fit : .fill)
                    .frame(width: playerManager.expanding ? 300 : 55, height: playerManager.expanding ? 300 : 55)
                    .cornerRadius(15)
                if !playerManager.expanding {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(playerManager.currentTrack?.name ?? "")
                            .font(.headline)
                            .fontWeight(.bold)
                            .lineLimit(playerManager.expanding ? 2 : 1)
                            .matchedGeometryEffect(id: "current_track_name", in: animation)
                        Text(playerManager.currentTrack?.artist.name ?? "")
                            .font(.subheadline)
                            .lineLimit(1)
                            .matchedGeometryEffect(id: "current_track_artist_name", in: animation)
                    }
                    Spacer(minLength: 0)
                    Button {
                        playerManager.playButtonSelected()
                    } label: {
                        Image(systemName: playerManager.onPlaying ? "pause" : "play.fill")
                            .font(.title3)
                            .foregroundColor(.primary)
                            .padding(10)
                            .matchedGeometryEffect(id: "play_track", in: animation)
                    }
                    
                    Button {
                        playerManager.nextButtonSelected()
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(.title3)
                            .padding(10)
                            .matchedGeometryEffect(id: "forward_track", in: animation)
                    }.buttonStyle(MusicPlayerButtonStyle())
                    .disabled(playerManager.isPreparing)
                }
            }
            .padding(.horizontal)
            if playerManager.expanding {
                Text(playerManager.currentTrack?.name ?? "")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding([.leading, .bottom, .trailing])
                    .matchedGeometryEffect(id: "current_track_name", in: animation)
                Text(playerManager.currentTrack?.artist.name ?? "")
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .padding([.leading, .bottom, .trailing])
                    .matchedGeometryEffect(id: "current_track_artist_name", in: animation)
                HStack(alignment: .center, spacing: 50) {
                    Button(action: {
                        playerManager.backButtonSelected()
                    }, label: {
                        Image(systemName: "backward.fill")
                            .font(.title3)
                            .padding(10)
                    })
                    .frame(width: 50, height: 50)
                    .disabled(playerManager.isFirstTrack || playerManager.isPreparing)
                    .buttonStyle(MusicPlayerButtonStyle())
                    Button(action: {
                        playerManager.playButtonSelected()
                    }, label: {
                        Image(systemName: playerManager.onPlaying ? "pause" : "play.fill")
                            .font(.title3)
                            .foregroundColor(.primary)
                            .padding(10)
                            .matchedGeometryEffect(id: "play_track", in: animation)
                    })
                    .frame(width: 50, height: 50)
                    Button(action: {
                        playerManager.nextButtonSelected()
                    }, label: {
                        Image(systemName: "forward.fill")
                            .font(.title3)
                            .padding(10)
                            .matchedGeometryEffect(id: "forward_track", in: animation)
                    })
                    .frame(width: 50, height: 50)
                    .buttonStyle(MusicPlayerButtonStyle())
                    .disabled(playerManager.isPreparing)
                }
                Button {
                    self.showPlaylistModelView = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                        .padding(10)
                        .frame(width: 50, height: 50)
                        .cornerRadius(25)
                }
                .buttonStyle(MusicPlayerButtonStyle())
                .sheet(isPresented: $showPlaylistModelView) {
                    if let trackID = playerManager.currentTrack?.id {
                        PlaylistModalView(showModalView: $showPlaylistModelView, trackID: trackID)
                    }
                }
            }
        }
        .onChange(of: playerManager.currentTrack, perform: { _ in
            DispatchQueue.global().async {
                if let url = playerManager.currentTrack?.album?.imageURL {
                    downloadImageAsync(url: url) { image in
                        self.image = image ?? UIImage()
                    }
                }
            }
        })
        .frame(maxWidth: .infinity, maxHeight: playerManager.expanding ? .infinity : MusicPlayerView.height)
        .background(
            VStack(spacing: 0) {
                BlurView()
                Divider()
            }.onTapGesture {
                withAnimation(.spring()) {
                    playerManager.expanding.toggle()
                }
            }
        )
        .cornerRadius(playerManager.expanding ? 20 : 0)
        // -48はtabItemの高さ分
        .offset(y: playerManager.expanding ? offset : -48)
        .gesture(DragGesture().onEnded(didEnd(value:)).onChanged(didChange(value:)))
        .ignoresSafeArea()
    }
    
    private func didChange(value: DragGesture.Value) {
        if value.translation.height > 0 && playerManager.expanding {
            offset = value.translation.height
        }
    }
    
    private func didEnd(value: DragGesture.Value) {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.95)) {
            if value.translation.height > 300 {
                playerManager.expanding = false
            }
            offset = 0
        }
    }
}

struct MusicPlayerView_Previews: PreviewProvider {
    @Namespace static var animation
    static var previews: some View {
        MusicPlayerView(animation: animation)
            .environmentObject(MusicPlayerManager.shared)
    }
}
