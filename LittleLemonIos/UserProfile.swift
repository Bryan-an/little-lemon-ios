//
//  UserProfile.swift
//  LittleLemonIos
//

import Foundation
import SwiftUI

struct UserProfile: View {
    @Environment(\.presentationMode) var presentation

    let firstName = UserDefaults.standard.string(forKey: kFirstName)
    let lastName = UserDefaults.standard.string(forKey: kLastName)
    let email = UserDefaults.standard.string(forKey: kEmail)

    var body: some View {
        VStack(spacing: 16) {
            Text("Personal information")
                .font(.title.bold())

            Image("profile-image-placeholder")
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)

            Text(firstName ?? "")
            Text(lastName ?? "")
            Text(email ?? "")

            Button("Logout") {
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                self.presentation.wrappedValue.dismiss()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    UserProfile()
}
