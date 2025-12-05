//
//  ScheduleManager.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang  on 12/5/25.
//

import SwiftUI
import Combine

class ScheduleManager: ObservableObject {
    static let shared = ScheduleManager()
    private init() {}

    @Published var addedSessions: [(session: Session, courseName: String)] = []

    func add(session: Session, courseName: String) {
        // avoid duplicates
        if !addedSessions.contains(where: { $0.session.id == session.id }) {
            addedSessions.append((session: session, courseName: courseName))
        }
    }
    
}

