//
//  SideMenu.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang  on 12/5/25.
//

import SwiftUI

struct SideMenuView: View {
    var onClose: () -> Void
    var onNavigateConnections: () -> Void

    var body: some View {
        ZStack(alignment: .leading) {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture { onClose() }

            VStack(alignment: .leading, spacing: 0) {

                HStack {
                    Spacer()
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .frame(height: 70)

                Button("My connections") {
                    onClose()
                    onNavigateConnections()
                }
                .padding()
                .foregroundColor(.white)

                Divider().background(Color.white.opacity(0.4))

                Button("Logout") {}
                    .padding()
                    .foregroundColor(.red)

                Spacer()
            }
            .frame(width: 260)
            .background(Color(hex: 0xF4B6C2))
            .ignoresSafeArea()
        }
    }
}
