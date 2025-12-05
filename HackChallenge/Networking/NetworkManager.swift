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

    private let baseURL = "http://10.49.85.198:8000"
}

extension NetworkManager {
    func getCourse(id: Int, completion: @escaping (Course?) -> Void) {
        let url = "\(baseURL)/courses/\(id)/"

        AF.request(url)
            .validate()
            .responseDecodable(of: Course.self) { response in
                switch response.result {
                case .success(let course):
                    completion(course)
                case .failure(let error):
                    print("Error fetching course details:", error)
                    completion(nil)
                }
            }
    }
    
    func getAllCourses(completion: @escaping ([Course]) -> Void) {
        let url = "\(baseURL)/courses/"

        AF.request(url)
            .validate()
            .responseDecodable(of: CourseListResponse.self) { response in
                switch response.result {
                case .success(let list):
                    completion(list.courses)
                case .failure(let error):
                    print("Error:", error)
                    completion([])
                }
            }
    }
}

extension NetworkManager {
    func getSession(id: Int, completion: @escaping (Session?) -> Void) {
        let url = "\(baseURL)/session/\(id)/"

        AF.request(url)
            .validate()
            .responseDecodable(of: Session.self) { response in
                switch response.result {
                case .success(let session):
                    completion(session)
                case .failure(let error):
                    print("Error fetching session:", error)
                    completion(nil)
                }
            }
    }
}

extension NetworkManager {
    func addSessionToUser(userID: Int, sessionID: Int, completion: @escaping (User?) -> Void) {
        let url = "\(baseURL)/users/\(userID)/schedule/"
        
        let params = ["session_id": sessionID]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: User.self) { response in
                switch response.result {
                case .success(let user):
                    completion(user)
                case .failure(let error):
                    print("Error adding session:", error)
                    completion(nil)
                }
            }
    }
}
