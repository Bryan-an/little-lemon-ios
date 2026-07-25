//
//  Theme.swift
//  LittleLemonIos
//
//  Little Lemon design system: brand colours, type scale and shared components.
//

import SwiftUI
import UIKit

// MARK: - Colours

extension Color {
    /// Primary brand surface — hero blocks and filled controls.
    static let llGreen = Color(red: 0x49 / 255, green: 0x5E / 255, blue: 0x57 / 255)

    /// Primary accent — calls to action and the wordmark.
    static let llYellow = Color(red: 0xF4 / 255, green: 0xCE / 255, blue: 0x14 / 255)

    /// Secondary accent.
    static let llSalmon = Color(red: 0xEE / 255, green: 0x99 / 255, blue: 0x72 / 255)

    /// Soft secondary tint.
    static let llPeach = Color(red: 0xFB / 255, green: 0xDA / 255, blue: 0xBB / 255)

    /// Section backgrounds, pills and search fields.
    static let llCloud = Color(red: 0xED / 255, green: 0xEF / 255, blue: 0xEE / 255)

    /// Body copy.
    static let llCharcoal = Color(red: 0x33 / 255, green: 0x33 / 255, blue: 0x33 / 255)
}

// MARK: - Type scale

// Little Lemon pairs Markazi Text (display) with Karla (body). Those font files
// are not bundled, so the roles map onto the system serif and sans faces.
extension Font {
    static let llDisplay = Font.system(size: 42, weight: .medium, design: .serif)
    static let llSubDisplay = Font.system(size: 30, weight: .regular, design: .serif)
    static let llSectionTitle = Font.system(size: 19, weight: .heavy)
    static let llCardTitle = Font.system(size: 17, weight: .bold)
    static let llBody = Font.system(size: 15)
    static let llLead = Font.system(size: 16, weight: .medium)
    static let llHighlight = Font.system(size: 16, weight: .bold)
    static let llCaption = Font.system(size: 12)
}

// MARK: - Logo

/// Simple vector stand-in for the Little Lemon lemon mark.
struct LemonMark: View {
    var size: CGFloat = 26

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Ellipse()
                .fill(Color.llYellow)
                .frame(width: size * 0.78, height: size)
                .rotationEffect(.degrees(-30))

            Ellipse()
                .fill(Color.llGreen)
                .frame(width: size * 0.34, height: size * 0.18)
                .rotationEffect(.degrees(-25))
                .offset(x: size * 0.04, y: -size * 0.04)
        }
        .frame(width: size, height: size)
    }
}

/// Lemon mark plus the letterspaced wordmark, used as a screen header.
struct BrandBar: View {
    var body: some View {
        HStack(spacing: 10) {
            LemonMark(size: 26)

            Text("LITTLE LEMON")
                .font(.system(size: 15, weight: .semibold))
                .kerning(2.5)
                .foregroundStyle(Color.llCharcoal)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.white)
    }
}

// MARK: - Controls

/// Primary action: yellow pill with charcoal label.
struct LittleLemonButtonStyle: ButtonStyle {
    var fullWidth = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.llHighlight)
            .foregroundStyle(Color.llCharcoal)
            .padding(.vertical, 14)
            .padding(.horizontal, 24)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .background(Color.llYellow, in: RoundedRectangle(cornerRadius: 10))
            .opacity(configuration.isPressed ? 0.75 : 1)
    }
}

/// Secondary action: filled green.
struct LittleLemonFilledStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.llLead)
            .foregroundStyle(.white)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(Color.llGreen, in: RoundedRectangle(cornerRadius: 8))
            .opacity(configuration.isPressed ? 0.75 : 1)
    }
}

/// Tertiary action: outlined.
struct LittleLemonOutlineStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.llLead)
            .foregroundStyle(Color.llGreen)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.llGreen.opacity(0.5), lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}

/// Field chrome shared by the registration and profile forms.
struct LittleLemonFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.llBody)
            .foregroundStyle(Color.llCharcoal)
            .padding(.horizontal, 12)
            .padding(.vertical, 11)
            .background(.white, in: RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.llGreen.opacity(0.35), lineWidth: 1)
            )
    }
}

extension View {
    func littleLemonField() -> some View {
        modifier(LittleLemonFieldModifier())
    }
}

/// Grey label stacked above a bordered field. `prominent` matches the larger
/// registration labels; the default matches the compact profile labels.
struct LabeledField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var contentType: UITextContentType?
    var keyboard: UIKeyboardType = .default
    var prominent = false
    var required = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(required ? "\(label) *" : label)
                .font(prominent ? .system(size: 18) : .llCaption)
                .foregroundStyle(Color.llCharcoal.opacity(prominent ? 0.55 : 0.7))

            TextField(placeholder, text: $text)
                .textContentType(contentType)
                .keyboardType(keyboard)
                .littleLemonField()
        }
    }
}

/// The green hero block: wordmark, city, blurb and dish photo. `footer` lets a
/// screen tuck extra chrome (the menu's search field) inside the block.
struct HeroBanner<Footer: View>: View {
    @ViewBuilder var footer: Footer

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Little Lemon")
                .font(.llDisplay)
                .foregroundStyle(Color.llYellow)

            Text("Chicago")
                .font(.llSubDisplay)
                .foregroundStyle(.white)
                .padding(.top, -8)

            HStack(alignment: .top, spacing: 16) {
                Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                    .font(.llLead)
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)

                Image("hero-image")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 130)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.top, 12)

            footer
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color.llGreen)
    }
}

extension HeroBanner where Footer == EmptyView {
    init() {
        self.init { EmptyView() }
    }
}

/// Category filter pill.
struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.llHighlight)
                .foregroundStyle(isSelected ? .white : Color.llGreen)
                .padding(.vertical, 10)
                .padding(.horizontal, 18)
                .background(
                    isSelected ? Color.llGreen : Color.llCloud,
                    in: Capsule()
                )
        }
        .buttonStyle(.plain)
    }
}

/// Square green checkbox used by the notification preferences.
struct LemonCheckbox: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(isOn ? Color.llGreen : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.llGreen, lineWidth: 1.5)
                    )
                    .frame(width: 20, height: 20)
                    .overlay {
                        if isOn {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .black))
                                .foregroundStyle(.white)
                        }
                    }

                Text(title)
                    .font(.llBody)
                    .foregroundStyle(Color.llCharcoal)

                Spacer()
            }
        }
        .buttonStyle(.plain)
    }
}
