//
//  Sessions.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang on 12/4/25.
//

import Foundation

struct Session: nonisolated Decodable, Identifiable {
    let id: Int
    let class_number: String
    let name: String
    let time: String
}


struct SessionSummary: Codable {
    let id: Int
    let class_number: String
    let name: String
    let time: String
}

struct ScheduleSession: Codable, Identifiable {
    let id: Int
    let class_number: String
    let name: String
    let time: String
    let course: ScheduleCourseSummary
}
