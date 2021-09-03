//
//  ListItemLayout1.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import SwiftUI

struct ListItem_Title_SubTitle_View: View {
    @State var image: UIImage = UIImage(systemName: "photo") ?? UIImage()
    let titleName: String
    let subTitleName: String
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(titleName)
                    .font(.system(size: 13, weight: .regular, design: .default))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    
                Text(subTitleName)
                    .font(.system(size: 11, weight: .thin, design: .default))
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
        }
    }
}

struct ListItemLayout1_Previews: PreviewProvider {
    static var previews: some View {
        let mock = AudioTrackModel.mock(1)
        ListItem_Title_SubTitle_View(
            titleName: mock.name,
            subTitleName: mock.artist.name
        )
    }
}
