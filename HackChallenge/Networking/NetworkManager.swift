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

//    private let baseURL = "http://10.49.85.198:8000"
    private let baseURL = "http://34.186.121.250:8000"
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
    func getSessions(sessionIDs: [Int], completion: @escaping ([Session]) -> Void) {
        var results: [Session] = []
        let group = DispatchGroup()

        for id in sessionIDs {
            group.enter()

            getSession(id: id) { session in
                if let session = session {
                    results.append(session)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(results.sorted { $0.id < $1.id })
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
    func googleLogin(tokenID: String, completion: @escaping (User?) -> Void) {
        let url = "\(baseURL)/auth/google"
        
        let params: [String: Any] = [
            "token_id": tokenID
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: User.self) { response in
                switch response.result {
                case .success(let user):
                    print("Backend returned user:", user)
                    completion(user)
                case .failure(let error):
                    print("Google backend login failed:", error)
                    completion(nil)
                }
            }
    }
}

extension NetworkManager {
    func updateUser(
        userID: Int,
        major: String,
        interests: [InterestInput],
        completion: @escaping (User?) -> Void
    ) {
        let url = "\(baseURL)/users/\(userID)/"

        let profilePic = CurrentUser.shared.user?.profile_picture ?? ""

        let params: [String: Any] = [
            "major": major,
            "profile_picture": profilePic,
            "interests": interests.map { ["name": $0.name, "category": $0.category] }
        ]

        print("Sending Update User JSON:", params)

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: User.self) { response in
                switch response.result {
                case .success(let updatedUser):
                    completion(updatedUser)
                case .failure(let error):
                    print("Update user failed:", error)
                    completion(nil)
                }
            }
    }
}

extension NetworkManager {
    func addSessionToUser(userID: Int, sessionID: Int, completion: @escaping (User?) -> Void) {
        let url = "\(baseURL)/users/\(userID)/schedule/\(sessionID)/"

        AF.request(url, method: .post)
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
    
    func getUserSchedule(userID: Int, completion: @escaping (ScheduleResponse) -> Void) {
        let url = "\(baseURL)/users/\(userID)/schedule/"

            AF.request(url)
                .validate()
                .responseDecodable(of: ScheduleResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        completion(data)
                    case .failure(let error):
                        print("Failed to load schedule:", error)
                    }
                }
        }
    
    func deleteSessionFromUser(userID: Int, sessionID: Int, completion: @escaping (User?) -> Void) {

        let url = "\(baseURL)/users/\(userID)/schedule/\(sessionID)/"

        AF.request(url, method: .delete)
            .validate()
            .responseDecodable(of: User.self) { response in
                switch response.result {
                case .success(let updatedUser):
                    completion(updatedUser)
                case .failure(let error):
                    print("❌ Failed to delete session:", error)
                    completion(nil)
                }
            }
    }
}

// MARK: - FRIEND LISTS

extension NetworkManager {

    func getConnections(userID: Int, completion: @escaping ([UserConnection]) -> Void) {
        let url = "\(baseURL)/users/\(userID)/friend/"

        AF.request(url)
            .validate()
            .responseDecodable(of: FriendListResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(data.friends.map {
                        UserConnection(id: $0.id, name: $0.name, email: $0.email)
                    })
                case .failure(let error):
                    print("Failed to load connections:", error)
                    completion([])
                }
            }
    }

    func getIncomingRequests(userID: Int, completion: @escaping ([UserConnection]) -> Void) {
        let url = "\(baseURL)/users/\(userID)/friend/requests/"

        AF.request(url)
            .validate()
            .responseDecodable(of: FriendListResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(data.friends.map {
                        UserConnection(id: $0.id, name: $0.name, email: $0.email)
                    })
                case .failure(let error):
                    print("Failed to load incoming requests:", error)
                    completion([])
                }
            }
    }

    func getOutgoingRequests(userID: Int, completion: @escaping ([UserConnection]) -> Void) {
        let url = "\(baseURL)/users/\(userID)/friend/outgoing/"

        AF.request(url)
            .validate()
            .responseDecodable(of: FriendListResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(data.friends.map {
                        UserConnection(id: $0.id, name: $0.name, email: $0.email)
                    })
                case .failure(let error):
                    print("Failed to load outgoing:", error)
                    completion([])
                }
            }
    }

    func respondToRequest(
        userID: Int,
        friendID: Int,
        action: String,
        completion: @escaping (Bool) -> Void
    ) {
        let url = "\(baseURL)/users/\(userID)/friends/\(friendID)/"

        AF.request(url, method: .post,
                   parameters: ["action": action],
                   encoding: JSONEncoding.default)
            .validate()
            .response { response in
                if response.error == nil {
                    completion(true)
                } else {
                    print("Failed to respond to friend request:", response.error!)
                    completion(false)
                }
            }
    }
}

extension NetworkManager {

    func getAllStudents(completion: @escaping ([SearchStudent]) -> Void) {
        let url = "\(baseURL)/students/"

        AF.request(url)
            .validate()
            .responseDecodable(of: StudentListResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(data.students)
                case .failure(let error):
                    print("Failed to load students:", error)
                    completion([])
                }
            }
    }
}
