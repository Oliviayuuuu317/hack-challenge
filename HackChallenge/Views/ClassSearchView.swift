//
//  ClassSearchView.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang  on 12/1/25.
//

import SwiftUI

struct ClassSearchView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var query = ""
    @State private var showFilters = false
    @State private var selectedType: ClassType? = nil   
    
    var filtered: [Class] {
        filteredClasses(query, selectedType: selectedType)
    }
    
    var body: some View {
        VStack {
            
            ZStack(alignment: .topTrailing) {
                
                HStack {
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20))
                            .foregroundColor(.white)

                        TextField("Search Class", text: $query)
                            .foregroundColor(.white)
                            .font(.system(size: 20))

                        Spacer()

                        // FILTER ICON
                        Button {
                            withAnimation { showFilters.toggle() }
                        } label: {
                            Image(systemName: "line.horizontal.3")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 55)
                    .background(Color(red: 0.80, green: 0.80, blue: 0.80))
                    .cornerRadius(28)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                if showFilters {
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Button("LEC") {
                            selectedType = .lec
                            showFilters = false
                        }
                        
                        Button("DIS") {
                            selectedType = .dis
                            showFilters = false
                        }
                        
                        Button("LAB") {
                            selectedType = .lab
                            showFilters = false
                        }
                    }
                    .padding(12)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.top, 60)
                    .padding(.trailing, 35)
                    .transition(.opacity)
                }
            }
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filtered) { classItem in
                        ClassCardView(classItem: classItem)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 10)
            }
        }
    }
}

#Preview {
    ClassSearchView()
}


func filteredClasses(_ query: String, selectedType: ClassType?) -> [Class] {
    
    sampleClasses.filter { classObj in
        
        let matchesQuery =
            query.isEmpty ||
            classObj.name.lowercased().contains(query.lowercased())
        let matchesType =
            (selectedType == nil) || (classObj.type == selectedType)
        
        return matchesQuery && matchesType
    }
}


