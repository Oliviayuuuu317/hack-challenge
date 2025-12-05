//
//  Sessions.swift
//  HackChallenge
//
//  Created by Ben Chen on 12/4/25.
//

import Foundation

struct Session: Codable, Identifiable {
    let id: Int
    let class_number: String
    let name: String
    let time: String

}

struct CourseSummary: Codable, Identifiable {
    let id: Int
    let code: String
    let name: String
}

