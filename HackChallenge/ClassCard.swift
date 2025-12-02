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
        HStack(alignment: .top, spacing: 16) {
            
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text("\(classItem.name) \(classItem.section)")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Time: \(classItem.time)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Days: \(classItem.days)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button {
                print("\(classItem.name) \(classItem.section) added")
            } label: {
                Image(systemName: "plus.circle")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    ClassCardView(classItem: Class(
        name: "CHEM 2070",
        section: "LEC 001",
        time: "8:00 AM – 8:50 AM",
        days: "MWF"
    ))
}
