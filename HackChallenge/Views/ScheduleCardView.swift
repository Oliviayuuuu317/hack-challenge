//
//  ScheduleCardView.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang  on 12/5/25.
//


import SwiftUI

struct ScheduleCardView: View {
    let session: Session
    let courseName: String

    var body: some View {
        HStack(spacing: 16) {

            // LEFT ICON BOX
            Image("chem")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)

            // MIDDLE TEXT CONTENT
            VStack(alignment: .leading, spacing: 5) {

                HStack(spacing: 6) {
                    Text("\(courseName)-\(session.name)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex:0x777777))

                }

                Text(session.time)
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex:0xC2C2C2))

            }

            }
        .padding(.vertical, 10)
        .padding(.horizontal, 4)
    }
}

#Preview {
    SessionCardView(
        session: Session(
            id: 1,
            class_number: "9712",
            name: "LEC001",
            time: "MoWeFri 8:00 AM – 8:50 AM"
        ),
        courseName: "Chem 2070"
    )
}
