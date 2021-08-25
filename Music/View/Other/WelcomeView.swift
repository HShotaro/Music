//
//  WelcomeView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/24.
//

import SwiftUI

struct WelcomeView: View {
    @State var isNavigate = false
    var body: some View {
        VStack(alignment: .center) {
            NavigationLink(destination: AuthView(),isActive: $isNavigate) {
                EmptyView()
            }
            .navigationTitle("Welcome Music")
            
            Button("Sign In With Spotify") {
                self.isNavigate = true
            }
            .padding(.horizontal, 20.0)
            .frame(height: 44.0)
            .font(.title2)
            .background(Color.green.opacity(0.2))
            .border(Color.green, width: 1)
            .cornerRadius(3.0)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
