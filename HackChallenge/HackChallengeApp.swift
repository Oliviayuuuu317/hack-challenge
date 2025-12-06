//
//  HackChallengeApp.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang  on 12/1/25.
//

import SwiftUI
import GoogleSignIn

@main
struct HackChallengeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @State private var isLoggedIn: Bool = false
    @State private var didCompleteOnboarding: Bool = false

    var body: some Scene {
        WindowGroup {
            Group {
                if !isLoggedIn {
                    LoginView(isLoggedIn: $isLoggedIn)

                } else if !didCompleteOnboarding {
                    WelcomeFlowView(didCompleteOnboarding: $didCompleteOnboarding)

                } else {
                    ContentView()
                }
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}
