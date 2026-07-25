//
//  Onboarding.swift
//  LittleLemonIos
//

import Foundation
import SwiftUI

let kFirstName = "little_lemon_first_name"
let kLastName = "little_lemon_last_name"
let kEmail = "little_lemon_email"
let kIsLoggedIn = "little_lemon_is_logged_in"

struct Onboarding: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var showError = false
    @State private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Register")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)

                TextField("First Name", text: $firstName)
                    .textContentType(.givenName)

                TextField("Last Name", text: $lastName)
                    .textContentType(.familyName)

                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                Button("Register") {
                    if !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, isValidEmail(email) {
                        UserDefaults.standard.set(firstName, forKey: kFirstName)
                        UserDefaults.standard.set(lastName, forKey: kLastName)
                        UserDefaults.standard.set(email, forKey: kEmail)
                        UserDefaults.standard.set(true, forKey: kIsLoggedIn)
                        showError = false
                        isLoggedIn = true
                    } else {
                        showError = true
                    }
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, alignment: .leading)

                if showError {
                    Text("Please fill in every field with a valid email address.")
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

                Spacer()
            }
            .textFieldStyle(.roundedBorder)
            .padding()
            .navigationDestination(isPresented: $isLoggedIn) {
                Home()
            }
            .onAppear {
                if UserDefaults.standard.bool(forKey: kIsLoggedIn) {
                    isLoggedIn = true
                }
            }
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^\S+@\S+\.\S{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
}

#Preview {
    Onboarding()
}
