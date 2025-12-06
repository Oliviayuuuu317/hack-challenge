//
//  SessionView.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang  on 12/5/25.
//

import SwiftUI

struct SessionView: View {
    let courseName: String
    let courseID: Int        

    @State private var sessions: [Session] = []
    @State private var isLoading = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Results")
                .font(.system(size: 32, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 40)

            if isLoading {
                ProgressView("Loading sessions...")
                    .padding(.top, 40)
            } else {
                ScrollView {
                    VStack {
                        ForEach(sessions) { session in
                            SessionCardView(session: session, courseName: courseName)
                                .padding(.horizontal, 37)
                        }
                    }
                }
                .padding(.top)
            }

            Spacer()
        }
        .padding(.top)
        .onAppear {
            loadSessions()
        }
    }

    func loadSessions() {
        NetworkManager.shared.getCourse(id: courseID) { course in
            DispatchQueue.main.async {
                self.sessions = course?.sessions ?? []
                self.isLoading = false
            }
        }
    }
}

