//
//  Courses.swift
//  HackChallenge
//
//  Created by Ben Chen on 12/4/25.
//

import Foundation

struct Course: Codable, Identifiable {
    let id: Int
    let code: String
    let name: String
    let sessions: [Session]?
}

// Used only for GET all courses (because top-level is { "courses": [...] })
struct CourseListResponse: Codable {
    let courses: [Course]
}
