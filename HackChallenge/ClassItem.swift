//
//  ClassItem.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang  on 12/1/25.
//

import Foundation
struct Class: Identifiable {
    let id = UUID()
    let name: String
    let section: String
    let time: String
    let days : String
}

let sampleClasses: [Class] = [
    Class(
        name: "CHEM 2070",
        section: "LEC 001",
        time: "8:00 AM – 8:50 AM",
        days: "MWF"
    ),
    Class(
        name: "CHEM 2070",
        section: "DIS 101",
        time: "11:00 AM – 11:50 AM",
        days: "W"
    ),
    Class(
        name: "MATH 2210",
        section: "LEC 002",
        time: "9:05 AM – 9:55 AM",
        days: "MTWRF"
    ),
    Class(
        name: "MATH 2210",
        section: "DIS 201",
        time: "2:40 PM – 3:30 PM",
        days: "T"
    ),
    Class(
        name: "CS 1110",
        section: "LEC 001",
        time: "10:10 AM – 11:00 AM",
        days: "MWF"
    ),
    Class(
        name: "CS 1110",
        section: "DIS 102",
        time: "3:45 PM – 4:35 PM",
        days: "R"
    ),
    Class(
        name: "BIOG 1440",
        section: "LEC 001",
        time: "1:25 PM – 2:15 PM",
        days: "MWF"
    ),
    Class(
        name: "BIOG 1440",
        section: "LAB 301",
        time: "7:30 PM – 9:25 PM",
        days: "T"
    )
]
