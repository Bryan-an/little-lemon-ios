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
let kPhoneNumber = "little_lemon_phone_number"
let kOrderStatuses = "little_lemon_notify_order_statuses"
let kPasswordChanges = "little_lemon_notify_password_changes"
let kSpecialOffers = "little_lemon_notify_special_offers"
let kNewsletter = "little_lemon_notify_newsletter"

struct Onboarding: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var showError = false
    @State private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                BrandBar()

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        welcome

                        form
                    }
                }
                .background(.white)
            }
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

    // MARK: - Sections

    private var welcome: some View {
        HeroBanner()
    }

    private var form: some View {
        VStack(alignment: .leading, spacing: 18) {
            LabeledField(
                label: "First name",
                placeholder: "First Name",
                text: $firstName,
                contentType: .givenName,
                prominent: true,
                required: true
            )

            LabeledField(
                label: "Last name",
                placeholder: "Last Name",
                text: $lastName,
                contentType: .familyName,
                prominent: true,
                required: true
            )

            LabeledField(
                label: "Email",
                placeholder: "Email",
                text: $email,
                contentType: .emailAddress,
                keyboard: .emailAddress,
                prominent: true,
                required: true
            )

            if showError {
                Text("Fill in every field and use a valid email address.")
                    .font(.llBody)
                    .foregroundStyle(Color.llSalmon)
            }

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
            .buttonStyle(LittleLemonButtonStyle())
            .padding(.top, 4)
        }
        .padding(20)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^\S+@\S+\.\S{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
}

#Preview {
    Onboarding()
}
