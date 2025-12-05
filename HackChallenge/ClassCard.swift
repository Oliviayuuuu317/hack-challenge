//
//  ClassCard.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang  on 12/1/25.
//

import SwiftUI

struct CourseCardView: View {
    let course: Course
    
    var body: some View {
        HStack(spacing: 16) {
            
            // Left rounded square icon
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue.opacity(0.1))
                .frame(width: 60, height: 60)
                .overlay(
                    Image("chem")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue.opacity(0.6))
                )
            
            // Course name + type
            VStack(alignment: .leading, spacing: 4) {
                Text(course.code)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(hex:0x777777))
                
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.6))
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

#Preview {
    CourseCardView(course: Course(
        id: 1,
        code: "AAS2130",
        name: "Intro to Asian American History",
        sessions: [
            Session(id: 1, class_number: "9709", name: "LEC001", time: "MW 10:10AM"),
            Session(id: 2, class_number: "9710", name: "DIS201", time: "F 10:10AM"),
            Session(id: 3, class_number: "9711", name: "DIS202", time: "F 11:15AM"),
            Session(id: 4, class_number: "9712", name: "DIS203", time: "F 12:20PM")
        ]
    ))}
