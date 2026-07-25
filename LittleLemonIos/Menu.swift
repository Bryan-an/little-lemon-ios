//
//  Menu.swift
//  LittleLemonIos
//

import SwiftUI

struct Menu: View {
    var body: some View {
        VStack {
            Text("Little Lemon")
                .font(.largeTitle.bold())

            Text("Chicago")
                .font(.title2)

            Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                .font(.body)
                .padding(.vertical, 8)

            List {
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    Menu()
}
