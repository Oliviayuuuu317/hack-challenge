//
//  WelcomeFlowView.swift
//  HackChallenge
//
//  Created by Ben Chen on 12/5/25.
//

import SwiftUI

// MARK: - ROOT ONBOARDING FLOW

struct WelcomeFlowView: View {
    @Binding var didCompleteOnboarding: Bool

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var pronouns = ""
    @State private var email = ""
    @State private var phone = ""

    var body: some View {
        NavigationStack {
            WelcomeScreen(
                firstName: $firstName,
                didCompleteOnboarding: $didCompleteOnboarding
            )
        }
        .ignoresSafeArea()
    }
}

// MARK: - SCREEN 1: Welcome

struct WelcomeScreen: View {
    @Binding var firstName: String
    @Binding var didCompleteOnboarding: Bool

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 40) {
                Spacer()

                Text("Welcome!")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                NavigationLink(
                    destination: NameScreen(
                        firstName: $firstName,
                        didCompleteOnboarding: $didCompleteOnboarding
                    )
                ) {
                    Text("Create profile")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: 0xF7798D))
                        .cornerRadius(16)
                        .padding(.horizontal, 40)
                }

                Spacer()
            }
        }
    }
}

// MARK: - SCREEN 2: Name + Pronouns

struct NameScreen: View {
    @Binding var firstName: String
    @Binding var didCompleteOnboarding: Bool

    @State private var lastName = ""
    @State private var pronouns = ""

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 25) {
                Spacer().frame(height: 60)

                Image("calendarIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140)

                CustomTextField("First name", text: $firstName)
                CustomTextField("Last name", text: $lastName)
                CustomTextField("Pronouns", text: $pronouns)

                NavigationLink(
                    destination: ContactScreen(
                        didCompleteOnboarding: $didCompleteOnboarding,
                        email: "",
                        phone: ""
                    )
                ) {
                    PinkNextButton()
                }

                Spacer()
            }
            .padding(.horizontal, 40)
        }
    }
}

// MARK: - SCREEN 3: Email + Phone

struct ContactScreen: View {
    @Binding var didCompleteOnboarding: Bool
    @State var email: String
    @State var phone: String

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 25) {
                Spacer().frame(height: 60)

                Image("calendarIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140)

                CustomTextField("Email", text: $email)
                CustomTextField("Phone number", text: $phone)

                Button {
                    // Done → tell app we finished onboarding
                    didCompleteOnboarding = true
                } label: {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: 0xF7798D))
                        .cornerRadius(16)
                        .padding(.horizontal, 40)
                }

                Spacer()
            }
            .padding(.horizontal, 40)
        }
    }
}

// MARK: - Reusable Components

struct PinkNextButton: View {
    var body: some View {
        Text("Next  >")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(hex: 0xF7798D))
            .cornerRadius(16)
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String

    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 1)
    }
}

struct GradientBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(hex: 0xFFC1CB),
                Color(hex: 0xE0F3FF),
                Color(hex: 0xFFF7E6)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}
