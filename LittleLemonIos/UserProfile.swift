//
//  UserProfile.swift
//  LittleLemonIos
//

import Foundation
import SwiftUI

struct UserProfile: View {
    @Environment(\.presentationMode) var presentation

    @State private var firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
    @State private var lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
    @State private var email = UserDefaults.standard.string(forKey: kEmail) ?? ""
    @State private var phone = UserDefaults.standard.string(forKey: kPhoneNumber) ?? ""

    @State private var orderStatuses = UserDefaults.standard.bool(forKey: kOrderStatuses)
    @State private var passwordChanges = UserDefaults.standard.bool(forKey: kPasswordChanges)
    @State private var specialOffers = UserDefaults.standard.bool(forKey: kSpecialOffers)
    @State private var newsletter = UserDefaults.standard.bool(forKey: kNewsletter)

    var body: some View {
        VStack(spacing: 0) {
            BrandBar()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Personal information")
                        .font(.llSectionTitle)
                        .foregroundStyle(Color.llCharcoal)

                    avatarRow

                    VStack(spacing: 16) {
                        LabeledField(
                            label: "First name",
                            placeholder: "First name",
                            text: $firstName,
                            contentType: .givenName
                        )

                        LabeledField(
                            label: "Last name",
                            placeholder: "Last name",
                            text: $lastName,
                            contentType: .familyName
                        )

                        LabeledField(
                            label: "Email",
                            placeholder: "Email",
                            text: $email,
                            contentType: .emailAddress,
                            keyboard: .emailAddress
                        )

                        LabeledField(
                            label: "Phone number",
                            placeholder: "(217) 555-0113",
                            text: $phone,
                            contentType: .telephoneNumber,
                            keyboard: .phonePad
                        )
                    }

                    notifications

                    Button("Log out") {
                        UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                        self.presentation.wrappedValue.dismiss()
                    }
                    .buttonStyle(LittleLemonButtonStyle())

                    HStack(spacing: 12) {
                        Button("Discard changes") {
                            discard()
                        }
                        .buttonStyle(LittleLemonOutlineStyle())

                        Button("Save changes") {
                            save()
                        }
                        .buttonStyle(LittleLemonFilledStyle())

                        Spacer()
                    }
                }
                .padding(20)
            }
            .background(.white)
        }
    }

    // MARK: - Sections

    private var avatarRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Avatar")
                .font(.llCaption)
                .foregroundStyle(Color.llCharcoal.opacity(0.7))

            HStack(spacing: 14) {
                Image("profile-image-placeholder")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())

                Button("Change") {}
                    .buttonStyle(LittleLemonFilledStyle())

                Button("Remove") {}
                    .buttonStyle(LittleLemonOutlineStyle())

                Spacer()
            }
        }
    }

    private var notifications: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Email notifications")
                .font(.llSectionTitle)
                .foregroundStyle(Color.llCharcoal)

            LemonCheckbox(title: "Order statuses", isOn: $orderStatuses)
            LemonCheckbox(title: "Password changes", isOn: $passwordChanges)
            LemonCheckbox(title: "Special offers", isOn: $specialOffers)
            LemonCheckbox(title: "Newsletter", isOn: $newsletter)
        }
    }

    // MARK: - Actions

    private func save() {
        UserDefaults.standard.set(firstName, forKey: kFirstName)
        UserDefaults.standard.set(lastName, forKey: kLastName)
        UserDefaults.standard.set(email, forKey: kEmail)
        UserDefaults.standard.set(phone, forKey: kPhoneNumber)
        UserDefaults.standard.set(orderStatuses, forKey: kOrderStatuses)
        UserDefaults.standard.set(passwordChanges, forKey: kPasswordChanges)
        UserDefaults.standard.set(specialOffers, forKey: kSpecialOffers)
        UserDefaults.standard.set(newsletter, forKey: kNewsletter)
    }

    private func discard() {
        firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
        lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
        email = UserDefaults.standard.string(forKey: kEmail) ?? ""
        phone = UserDefaults.standard.string(forKey: kPhoneNumber) ?? ""
        orderStatuses = UserDefaults.standard.bool(forKey: kOrderStatuses)
        passwordChanges = UserDefaults.standard.bool(forKey: kPasswordChanges)
        specialOffers = UserDefaults.standard.bool(forKey: kSpecialOffers)
        newsletter = UserDefaults.standard.bool(forKey: kNewsletter)
    }
}
