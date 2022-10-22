//
//  ToggleView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import SwiftUI

struct SelectorView: View {
    static let height: CGFloat = textHeight + indicatorHeight + dividerHeight
    static let textHeight: CGFloat = 44
    static let indicatorHeight: CGFloat = 3
    static let dividerHeight: CGFloat = 1
    @Binding var selectedIndex: Int
    @Binding var offset: CGFloat
    let items: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .foregroundColor(Color(.white))
                        .fontWeight(selectedIndex == items.firstIndex(of: item) ? .bold : .regular)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.width / CGFloat(items.count), height: SelectorView.textHeight)
                        .background(
                            Color.primaryColor
                                .onTapGesture {
                                    withAnimation {
                                        selectedIndex = items.firstIndex(of: item) ?? 0
                                        offset = -UIScreen.main.bounds.width * CGFloat(selectedIndex)
                                    }
                                }
                        )
                }
            }
            Color(.white)
                .frame(width: UIScreen.main.bounds.width / CGFloat(items.count), height: SelectorView.indicatorHeight)
                .cornerRadius(SelectorView.indicatorHeight/2)
                .offset(x: -offset / CGFloat(items.count))
            Divider()
                .frame(height: SelectorView.dividerHeight)
        }
        .padding(.top, SelectorView.statusBarHeight())
        .background(Color.primaryColor)
        .edgesIgnoringSafeArea(.top)
        .frame(width: UIScreen.main.bounds.width, height: SelectorView.height)
    }
    
    static func statusBarHeight() -> CGFloat{
        let statusBarHeight: CGFloat = UIApplication.shared.connectedScenes
            .filter {$0.activationState == .foregroundActive }
            .map {$0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter({ $0.isKeyWindow }).first?
            .windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return statusBarHeight
    }
}

struct ToggleView_Previews: PreviewProvider {
    @State static var selectedIndex = 0
    @State static var offset = CGFloat(0)
    static var previews: some View {
        SelectorView(selectedIndex: $selectedIndex, offset: $offset, items: ["Playlist", "Album"])
    }
}
