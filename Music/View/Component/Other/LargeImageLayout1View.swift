//
//  LargeImageLayout1.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import SwiftUI

struct LargeImageLayout1View: View {
    @State var image: UIImage = UIImage(systemName: "photo") ?? UIImage()
    @Binding var showPlayerView: Bool
    let imageURL: URL?
    var body: some View {
        HStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.all)
                .frame(width: 160, height: 160, alignment: .leading)
            Spacer()
            Button(action: {
                showPlayerView.toggle()
            }, label: {
                Image(systemName: "play.fill")
                    .frame(width: 60, height: 60)
                    .background(Color.green)
                    .cornerRadius(30)
            })
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
}

struct LargeImageLayout1_Previews: PreviewProvider {
    static var previews: some View {
        let mock = PlaylistDetailModel.mock(1)
        let showPlayerView = Binding<Bool>.init(get: {
            return false
        }, set: {_ in })
        LargeImageLayout1View(
            showPlayerView: showPlayerView, imageURL: mock.imageURL
        )
    }
}
