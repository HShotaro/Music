//
//  MypageView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import SwiftUI

struct MypageView: View {
    @EnvironmentObject var authManager: AuthManager
    var body: some View {
        Button {
            authManager.signOut()
        } label: {
            Text("Sing Out")
        }

    }
}

struct MypageView_Previews: PreviewProvider {
    static var previews: some View {
        MypageView()
    }
}
