//
//  LargeImageLayout1.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import SwiftUI

struct LargeImageLayout1View: View {
    @State var image: UIImage = UIImage(systemName: "photo") ?? UIImage()
    let imageURL: URL?
    let titleName: String
    var body: some View {
        HStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.all)
                .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.width / 2.5, alignment: .center)
            VStack(alignment: .center) {
                Text(titleName)
                Spacer()
                    .frame(height: 5.0)
                Button(action: {
                    print("dd")
                }, label: {
                    Image(systemName: "play.fill")
                        .frame(width: 60, height: 60)
                        .background(Color.green)
                        .cornerRadius(30)
                })
            }
            .padding([.top, .bottom, .trailing])
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
        LargeImageLayout1View(
            imageURL: mock.imageURL,
            titleName: mock.name
        )
    }
}
