//
//  Student.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang on 12/4/25.
//

import Foundation

struct Student: Codable, Identifiable {
    let id: Int
    let name: String
}

struct User: nonisolated Decodable, Identifiable {
    let id: Int                         // "id": 1
    let google_id: String               // "google_id": "1107..."
    let name: String                    // "name": "Olivia Yu"
    let email: String                   // "email": "qy265@cornell.edu"
    let profile_picture: String         // "profile_picture": ""
    let major: String                   // "major": ""
    let interests: String               // "interests": ""
    let sessions: [Session]             // "sessions": []
    let friendships: [Friendship]       // "friendships": []
}

struct Friendship: nonisolated Decodable, Identifiable {
    var id: Int { friend_id }
    let friend_id: Int
    let status: String
}
