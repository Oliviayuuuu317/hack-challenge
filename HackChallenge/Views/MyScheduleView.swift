//
//  MyScheduleView.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang  on 12/5/25.
//
import SwiftUI
struct MyScheduleView: View {
    @ObservedObject var schedule = ScheduleManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            Text("My schedule")
                .font(.largeTitle)
                .bold()

            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.black, lineWidth: 2)
                .frame(height: 250)
                .overlay(
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {

                            ForEach(schedule.addedSessions, id: \.session.id) { item in
                                ScheduleCardView(
                                    session: item.session,
                                    courseName: item.courseName
                                )
                            }

                        }
                        .padding(.top, 10)
                    }
                )

            Spacer()
        }
        .padding(.horizontal,40)
    }
}



