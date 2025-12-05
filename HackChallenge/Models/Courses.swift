//
//  Courses.swift
//  HackChallenge
//
//  Created by Ben Chen on 12/4/25.
//

import Foundation

struct Course: nonisolated Decodable, Identifiable {
    let id: Int
    let code: String
    let name: String
    let sessions: [Session]?
}

// Used only for GET all courses (because top-level is { "courses": [...] })
struct CourseListResponse: nonisolated Decodable {
    let courses: [Course]
}

let sampleCourses: [Course] = [
    Course(
        id: 1,
        code: "AAS2130",
        name: "Intro to Asian American History",
        sessions: [
            Session(id: 1, class_number: "9709", name: "LEC001", time: "MW 10:10AM"),
            Session(id: 2, class_number: "9710", name: "DIS201", time: "F 10:10AM"),
            Session(id: 3, class_number: "9711", name: "DIS202", time: "F 11:15AM"),
            Session(id: 4, class_number: "9712", name: "DIS203", time: "F 12:20PM")
        ]
    ),

    Course(
        id: 2,
        code: "CS1110",
        name: "Introduction to Computing Using Python",
        sessions: [
            Session(id: 7, class_number: "2221", name: "LEC002", time: "TR 2:55PM"),
            Session(id: 8, class_number: "2222", name: "DIS203", time: "R 11:20AM")
        ]
    ),

    Course(
        id: 3,
        code: "BIOG1440",
        name: "Introductory Biology: Comparative Physiology",
        sessions: [
            Session(id: 5, class_number: "1234", name: "LEC001", time: "MWF 1:25PM"),
            Session(id: 6, class_number: "1235", name: "DIS201", time: "T 7:30PM")
        ]
    ),

    Course(
        id: 4,
        code: "MATH2210",
        name: "Linear Algebra",
        sessions: nil   // ❗Example course with no sessions loaded
    )
]


let sampleSessions: [Session] = [
    Session(id: 1, class_number: "9709", name: "LEC001", time: "MW 10:10AM"),
    Session(id: 2, class_number: "9710", name: "DIS201", time: "F 10:10AM"),
    Session(id: 3, class_number: "9711", name: "DIS202", time: "F 11:15AM"),
    Session(id: 4, class_number: "9712", name: "DIS203", time: "F 12:20PM"),

    Session(id: 5, class_number: "1234", name: "LEC001", time: "MWF 1:25PM"),
    Session(id: 6, class_number: "1235", name: "DIS201", time: "T 7:30PM"),

    Session(id: 7, class_number: "2221", name: "LEC002", time: "TR 2:55PM"),
    Session(id: 8, class_number: "2222", name: "DIS203", time: "R 11:20AM")
]
