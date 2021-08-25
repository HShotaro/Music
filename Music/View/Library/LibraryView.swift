//
//  LibraryView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/24.
//

import SwiftUI

struct LibraryView: View {
    var body: some View {
        NavigationView {
            Text(/*@START_MENU_TOKEN@*/"Library"/*@END_MENU_TOKEN@*/)
            .navigationTitle("Library")
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
