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
    @State private var courses: [Course] = []
    @State private var isLoading = true
    
    // MARK: - Filtered Courses
    var filtered: [Course] {
        courses.filter { course in
            
            if let courseSessions = course.sessions {
                let addedIDs = ScheduleManager.shared.addedSessions.map { $0.session.id }
                let remaining = courseSessions.filter { !addedIDs.contains($0.id) }
                
                if remaining.isEmpty { return false }
            }

            if query.isEmpty { return true }
            let q = query.lowercased()

            return course.code.lowercased().hasPrefix(q) 
        }
    }
    
    var body: some View {
        VStack {
            
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                
                TextField("Search Course", text: $query)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(height: 40)
            .background(Color(hex:0xFFC1CB))
            .cornerRadius(28)
            .padding(.horizontal, 30)
            .padding(.top, 8)
            
            if isLoading {
                ProgressView("Loading courses...")
                    .padding(.top, 40)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filtered) { course in
                            NavigationLink {
                                SessionView(
                                    courseName: course.code,
                                    courseID: course.id
                                )
                            } label: {
                                CourseCardView(course: course)
                            }
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 25)
                }
            }
        }
        .onAppear {
            loadCourses()
        }
    }
    
    // MARK: - API Fetch
    func loadCourses() {
        NetworkManager.shared.getAllCourses { fetchedCourses in
            DispatchQueue.main.async {
                self.courses = fetchedCourses
                self.isLoading = false
            }
        }
    }
}

#Preview {
    ClassSearchView()
}
