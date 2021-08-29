//
//  MusicPlayerImageView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import SwiftUI

struct MusicPlayerImageView: View {
    @State var image: UIImage = UIImage(systemName: "photo") ?? UIImage()
    @Binding var imageURL: URL?
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.all, 0.0)
                .frame(width: 300, height: 300, alignment: .center)
        }.onChange(of: imageURL, perform: { _ in
            DispatchQueue.global().async {
                if let url = imageURL {
                    downloadImageAsync(url: url) { image in
                        self.image = image ?? UIImage()
                    }
                }
            }
        })
    }
}

struct MusicPlayerImageView_Previews: PreviewProvider {
    static var previews: some View {
        let binding = Binding<URL?>.init {
            AudioTrackModel.mock(1).album.imageURL
        } set: { _ in }
        MusicPlayerImageView(imageURL: binding)
    }
}
