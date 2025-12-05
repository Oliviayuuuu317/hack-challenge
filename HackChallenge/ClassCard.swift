//
//  ClassCard.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang  on 12/1/25.
//

import SwiftUI

struct ClassCardView: View {
    let classItem: Class
    
    var body: some View {
        HStack(spacing: 16) {
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.88, green: 0.95, blue: 1.0))
                .frame(width: 70, height: 70)
            
            VStack(alignment: .leading, spacing: 6) {
                
                HStack(spacing: 8) {
                    Text("\(classItem.name) \(classItem.section)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                
                    if classItem.type == .lab {
                        Text("LAB")
                            .font(.system(size: 14))
                            .foregroundColor(Color(.lightGray))
                    }else if classItem.type == .lec {
                        Text("LEC")
                            .font(.system(size: 14))
                            .foregroundColor(Color(.lightGray))
                    }else{
                        Text("DIS")
                            .font(.system(size: 14))
                            .foregroundColor(Color(.lightGray))
                    }
                    
                }
                
                Text("\(classItem.days) \(classItem.time)")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.lightGray))
                
                Text("\(classItem.location)")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.lightGray))
            }
            
            Spacer()
            
            VStack() {
                Spacer()
                Button(action: {
                    print("Added \(classItem.name) \(classItem.section)")
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(red: 0.93, green: 0.38, blue: 0.38))
                        .padding(6)
                        .overlay(
                            Circle()
                                .stroke(Color(red: 0.93, green: 0.38, blue: 0.38), lineWidth: 3)
                        )
            }
            }
        }
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
    ClassCardView(classItem: Class(name: "CHEM 2070", section: "001", time: "8:00 AM – 8:50 AM", days: "MWF", location: "Baker Laboratory 200", type: .lec))
}
