//
//  NetworkManager.swift
//  HackChallenge
//
//  Created by Ben Chen on 12/4/25.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    private let baseURL = "http://127.0.0.1:8000"

    // GET all courses
    func getCourses() async throws -> [Course] {
        let url = URL(string: "\(baseURL)/courses/")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(CourseListResponse.self, from: data)
        return decoded.courses
    }

    // GET course by id
    func getCourse(id: Int) async throws -> Course {
        let url = URL(string: "\(baseURL)/courses/\(id)/")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Course.self, from: data)
    }

    // GET session by id
    func getSession(id: Int) async throws -> Session {
        let url = URL(string: "\(baseURL)/session/\(id)/")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Session.self, from: data)
    }
}
