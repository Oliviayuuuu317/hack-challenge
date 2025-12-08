//
//  Student.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang on 12/4/25.
//

import Foundation
import Combine
import UIKit

struct Student: Codable, Identifiable {
    let id: Int
    let name: String
}

struct User: nonisolated Decodable, Identifiable {
    let id: Int
    let google_id: String
    let name: String
    let email: String
    let profile_picture: String?
    let major: Major?
    let interests: [Interest]
    let sessions: [SessionSummary]
    let friendships: [Friendship]
}

struct Friend: nonisolated Decodable, Identifiable {
    let id: Int
    let name: String
    let email: String
}

struct FriendListResponse: nonisolated Decodable {
    let friends: [Friend]
}

struct Friendship: nonisolated Decodable, Identifiable {
    var id: Int { friend_id }
    let friend_id: Int
    let status: String
}

struct StudentListResponse: nonisolated Decodable {
    let students: [SearchStudent]
}

struct SearchStudent: nonisolated Decodable, Identifiable {
    let id: Int
    let name: String
    let email: String
    let courses: [String]
}

struct Major: Codable {
    let id: Int
    let major: String
}

struct Interest: Codable {
    let id: Int?
    let name: String
    let category_id: Int?
}

struct InterestInput: Encodable {
    let name: String
    let category: String
}

class CurrentUser: ObservableObject {

    static let shared = CurrentUser()
    private init() {}

    @Published var user: User?

    private var profileImageCache: [Int: UIImage] = [:]

    private func profileImageURL(for userID: Int) -> URL? {
        let fm = FileManager.default
        do {
            let docs = try fm.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            return docs.appendingPathComponent("profile_\(userID).jpg")
        } catch {
            print("❌ Failed to get documents directory:", error)
            return nil
        }
    }

    func profileImage(for userID: Int) -> UIImage? {
        if let cached = profileImageCache[userID] {
            return cached
        }

        guard let url = profileImageURL(for: userID),
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            if let image = UIImage(data: data) {
                profileImageCache[userID] = image
                return image
            }
        } catch {
            print("❌ Failed to load profile image from disk:", error)
        }

        return nil
    }

    func setProfileImage(_ image: UIImage?, for userID: Int) {
        profileImageCache[userID] = image

        guard let url = profileImageURL(for: userID) else { return }
        let fm = FileManager.default

        guard let image = image else {
            do {
                if fm.fileExists(atPath: url.path) {
                    try fm.removeItem(at: url)
                }
            } catch {
                print("❌ Failed to remove profile image from disk:", error)
            }
            return
        }

        if let data = image.jpegData(compressionQuality: 0.9) ?? image.pngData() {
            do {
                try data.write(to: url, options: .atomic)
            } catch {
                print("❌ Failed to write profile image to disk:", error)
            }
        }
    }
}

struct ScheduleResponse: nonisolated Decodable {
    let sessions: [ScheduleSession]
}
