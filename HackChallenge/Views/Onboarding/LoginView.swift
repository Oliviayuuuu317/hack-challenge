//
//  LoginView.swift
//  HackChallenge
//
//  Created by Ben Chen on 12/4/25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack(spacing: 40) {

            Spacer()

            Text("Welcome!\nPlease sign in")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.vertical, 40)

            Image("logo2")
                .resizable()
                .scaledToFill()

            Spacer()
                .frame(height: 20)

            Button(action: {
                performGoogleLogin()
            }) {
                HStack {
                    Image("googlelogo")
                        .resizable()
                        .frame(width: 24, height: 24)

                    Text("Continue with Google")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(40)
                .shadow(radius: 4)
                .padding(.horizontal, 40)
            }

            Spacer()
                .frame(height: 40)
        }
        .background(
            LinearGradient(
                colors: [
                    Color(hex: 0xFFC1CB),
                    Color(hex: 0xE0F3FF),
                    Color(hex: 0xFFF7E6)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .ignoresSafeArea()
    }

    func performGoogleLogin() {

        guard let rootViewController = UIApplication
            .shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?
            .rootViewController
        else {
            print("❌ No root view controller found")
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in

            if let error = error {
                print("❌ Google Sign-In error: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user else {
                print("❌ No user object returned")
                return
            }

            print("✅ Signed in as:", user.profile?.name ?? "Unknown")
            isLoggedIn = true
        }
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
}
