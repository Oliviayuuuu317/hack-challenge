//
//  ClassSearchView.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang  on 12/1/25.
//

import SwiftUI

struct ClassSearchView: View {
    @State private var searchText = ""
    let classes: [Class] = sampleClasses   
    var filteredClasses: [Class] {
        if searchText.isEmpty {
            return classes
        }
        return classes.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(filteredClasses) { classItem in
                        ClassCardView(classItem: classItem)
                    }
                }
                .padding()
            }
            .navigationTitle("Find Classes")
            .searchable(text: $searchText, prompt: "Search classes")
        }
    }
}

#Preview {
    ClassSearchView()
}

