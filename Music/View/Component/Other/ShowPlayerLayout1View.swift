//
//  LargeImageLayout1.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import SwiftUI

struct ShowPlayerLayout1View: View {
    @State var image: UIImage = UIImage(systemName: "photo") ?? UIImage()
    @EnvironmentObject var playerManager: MusicPlayerManager
    var tapPlayerViewHandler: (() -> Void)?
    let imageURL: URL?
    let tracks: [AudioTrackModel]
    var body: some View {
        HStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.all)
                .frame(width: 160, height: 160, alignment: .leading)
            Spacer()
            Button.init(action: showMusicPlayer) {
                Image(systemName: "play.fill")
                    .frame(width: 60, height: 60)
                    .background(Color.green)
                    .cornerRadius(30)
            }
            .padding([.bottom, .trailing])
            .padding(.top, 90.0)
        }
        .onAppear {
            DispatchQueue.global().async {
                if let url = imageURL {
                    downloadImageAsync(url: url) { image in
                        self.image = image ?? UIImage()
                    }
                }
            }
        }
    }
    
    func showMusicPlayer() {
        withAnimation(.spring()) {
            playerManager.showMusicPlayer(tracks: tracks)
        }
    }
}

struct LargeImageLayout1_Previews: PreviewProvider {
    static var previews: some View {
        let mock = PlaylistDetailModel.mock(1)
        ShowPlayerLayout1View(
            imageURL: mock.imageURL, tracks: mock.tracks
        )
    }
}
