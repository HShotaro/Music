//
//  HomePlaylistView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/25.
//

import SwiftUI

struct HomePlaylistView: View {
    @State var image: UIImage = UIImage(systemName: "photo") ?? UIImage()
    let playlist: PlayListModel
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .padding([.top, .leading, .trailing], 0.0)
                .aspectRatio(1, contentMode: .fit)
                .frame(width: (UIScreen.main.bounds.width - 30) / 2)
            Text(playlist.name)
                .fontWeight(.regular)
                .multilineTextAlignment(.leading)
                .padding([.leading, .bottom, .trailing])
                .font(.subheadline)
                .frame(height: 20.0)
            Text(playlist.creatorName)
                .fontWeight(.light)
                .multilineTextAlignment(.leading)
                .font(.caption)
                .padding([.leading, .bottom, .trailing])
                .frame(height: 15.0)
        }.onAppear {
            if let url = playlist.imageURL {
                downloadImageAsync(url: url) { image in
                    self.image = image ?? UIImage()
                }
            }
        }
    }
}

struct HomePlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        HomePlaylistView(playlist: PlayListModel.mock(1))
    }
}
