//
//  HomeView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/24.
//

import SwiftUI

struct HomeView: View {
    static let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 5, alignment: .center), count: 3)
    var body: some View {
        ScrollView {
             LazyVGrid(columns: HomeView.columns) {
                 ForEach((0...50), id: \.self) { i in
                    DummyView(
                        text: "\(i)"
                    ).background(Color.pink)
                 }
             }.font(.largeTitle)
         }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct DummyView: View {
    let text: String
    var body: some View {
        Text(text)
    }
}
