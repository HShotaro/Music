//
//  LazyPineedView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/02.
//

import SwiftUI

struct LazyPinnedView: View {
    private var title: String
    private var color: Color

    init(title: String, color : Color){
        self.title = title
        self.color = color
    }

    var body: some View {
        Divider()
        HStack {
            Text("\(title)")
                .font(.headline)
                .fontWeight(.bold)
        }.padding(.vertical, 5)
        .padding(.horizontal, 15)
        .background(color)
    }
}

struct LLazyPinnedView_Previews: PreviewProvider {
    static var previews: some View {
        LazyPinnedView(title:"previewHeader", color :Color.blue)
    }
}
