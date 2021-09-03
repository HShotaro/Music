//
//  ToggleView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import SwiftUI

struct ToggleView: View {
    @Binding var selectedIndex: Int
    @Binding var offset: CGFloat
    let items: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                ForEach(items, id: \.self) { item in
                    Button(action: {
                        withAnimation {
                            selectedIndex = items.firstIndex(of: item) ?? 0
                            offset = -UIScreen.main.bounds.width * CGFloat(selectedIndex)
                        }
                    }, label: {
                        Text(item)
                            .foregroundColor(Color(.label))
                            .fontWeight(selectedIndex == items.firstIndex(of: item) ? .bold : .regular)
                            .multilineTextAlignment(.center)
                    }).frame(width: UIScreen.main.bounds.width / CGFloat(items.count), height: 44)
                }
                Spacer()
            }
            Color(.label)
                .frame(width: UIScreen.main.bounds.width / CGFloat(items.count), height: 3)
                .cornerRadius(1.5)
                .offset(x: -offset / CGFloat(items.count))
        }.frame(width: UIScreen.main.bounds.width, height: 47)
        .background(Color.primaryColor)
    }
}

struct ToggleView_Previews: PreviewProvider {
    @State static var selectedIndex = 0
    @State static var offset = CGFloat(0)
    static var previews: some View {
        ToggleView(selectedIndex: $selectedIndex, offset: $offset, items: ["Playlist", "Album"])
    }
}
