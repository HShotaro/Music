//
//  MypageView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/09/03.
//

import SwiftUI

struct MypageView: View {
    @EnvironmentObject var authManager: AuthManager
    @State var presentAlert = false
    var body: some View {
        Button {
            presentAlert = true
        } label: {
            Text("サインアウト")
        }.alert(isPresented: $presentAlert, content: {
            Alert(title: Text("サインアウトしてもよろしいですか？"), primaryButton: Alert.Button.destructive(Text("はい"), action: {
                authManager.signOut()
            }), secondaryButton: Alert.Button.cancel(Text("キャンセル"))
            )
        })
        .navigationBarTitleDisplayMode(.inline)

    }
}

struct MypageView_Previews: PreviewProvider {
    static var previews: some View {
        MypageView()
    }
}
