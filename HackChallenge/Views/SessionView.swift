//
//  SessionView.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang  on 12/5/25.
//

import SwiftUI

struct SessionView: View {
    @Environment(\.dismiss) var dismiss
    
    let courseName: String
    let sessions: [Session]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Results")
                .font(.system(size: 32, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading,40)

            // RESULTS LIST
            ScrollView {
                VStack() {
                    ForEach(sessions.filter { session in
                        let addedIDs = ScheduleManager.shared.addedSessions.map { $0.session.id }
                        return !addedIDs.contains(session.id)   // Hide if added
                    }) { session in
                        SessionCardView(session: session, courseName: courseName)
                            .padding(.horizontal, 37)
                    }
                }
            }
            .padding(.top)
            Spacer()
        }
        .padding(.top)
    }
}

#Preview {
    SessionView(
        courseName: "Chem 2070",
        sessions: [
            Session(
                id: 1,
                class_number: "9709",
                name: "LEC001",
                time: "MoWeFri 8:00 AM – 8:50 AM"
            ),
            Session(
                id: 2,
                class_number: "9710",
                name: "LEC002",
                time: "MoWeFri 11:15 AM – 12:05 PM"
            )
        ]
    )
}
