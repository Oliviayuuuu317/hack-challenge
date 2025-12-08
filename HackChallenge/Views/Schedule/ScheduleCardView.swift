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
            
            Image("chem")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            
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
            
            Spacer()
            
            VStack{
                Spacer()
                Button(action: {
                    ScheduleManager.shared.remove(sessionID: session.id)
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 15, height: 15)
                        
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 10, height: 2)
                    }
                }
            }
        }
        .padding(.top, 10)
    }
}

#Preview {
    ScheduleCardView(
        session: Session(
            id: 1,
            class_number: "9712",
            name: "LEC001",
            time: "MoWeFri 8:00 AM – 8:50 AM"
        ),
        courseName: "Chem 2070"
    )
}
