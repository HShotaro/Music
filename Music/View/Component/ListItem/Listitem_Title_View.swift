//
//  Listitem_Title_View.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import SwiftUI

struct Listitem_Title_View: View {
    let title: String
    let font: Font
    let fontWight: Font.Weight
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(font)
                    .fontWeight(fontWight)
                    .foregroundColor(Color(UIColor.label))
                    .lineLimit(1)
                Spacer()
            }
            Divider()
        }.padding(.horizontal, 12)
        
    }
}

struct Listitem_Title_View_Previews: PreviewProvider {
    static var previews: some View {
        Listitem_Title_View(title: "title", font: .headline, fontWight: .bold)
    }
}
