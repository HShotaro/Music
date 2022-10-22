//
//  WelcomeView.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/24.
//

import SwiftUI

struct WelcomeView: View {
    @State var path: [SMPageDestination] = []
    var body: some View {
        VStack(alignment: .center) {
            SMNavigationView(navigationTitle: "Welcome Music", path: $path) {
                if #available(iOS 16.0, *) {
                    Button("Sign In With Spotify") {
                        self.path.append(.authView)
                    }
                    .padding(.horizontal, 20.0)
                    .frame(height: 44.0)
                    .font(.title2)
                    .background(Color.green.opacity(0.2))
                    .border(Color.green, width: 1)
                    .cornerRadius(3.0)
                } else {
                    NavigationLink {
                        AuthView()
                    } label: {
                        Text("Sign In With Spotify")
                            .padding(.horizontal, 20.0)
                            .frame(height: 44.0)
                            .font(.title2)
                            .background(Color.green.opacity(0.2))
                            .border(Color.green, width: 1)
                            .cornerRadius(3.0)
                    }
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
