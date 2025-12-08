//
//  ContentView.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang on 11/30/25.
//

import SwiftUI

enum TopTab {
    case profile
    case search
}

struct ContentView: View {

    // MARK: - Login Bindings

    @Binding var isLoggedIn: Bool
    @Binding var didCompleteOnboarding: Bool

    @State private var selectedTab: TopTab = .profile
    @State private var userBio = "Hi, I'm Ben!"
    @State private var userName = "Ben Chen"
    @State private var userEmail = "bc679@cornell.edu"
    @State private var userMajor = ""
    @State private var userImage: UIImage? = nil
    @State private var navigateToConnections = false
    @State private var searchCourse = ""
    @State private var showMenu = false

    let allStudents: [SearchStudent] = [
        SearchStudent(id: 1, name: "Mr. Eggplant",
                      email: "eggplant@cornell.edu",
                      courses: ["CHEM 2070", "MATH 1110"]),
        SearchStudent(id: 2, name: "Benjamin Chenjamin",
                      email: "bc679@cornell.edu",
                      courses: ["CHEM 2070", "BIO 1010"]),
        SearchStudent(id: 3, name: "Walter White",
                      email: "wwhite@cornell.edu",
                      courses: ["CHEM 3570"])
    ]

    // MARK: - Init to preload profile image if available

    init(isLoggedIn: Binding<Bool>, didCompleteOnboarding: Binding<Bool>) {
        self._isLoggedIn = isLoggedIn
        self._didCompleteOnboarding = didCompleteOnboarding

        if let user = CurrentUser.shared.user {
            let initialImage = CurrentUser.shared.profileImage(for: user.id)
            _userImage = State(initialValue: initialImage)
            _userName = State(initialValue: user.name)
            _userEmail = State(initialValue: user.email)
            if let major = user.major?.major {
                _userMajor = State(initialValue: major)
            }
        }
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {

                    topBar

                    if selectedTab == .profile {
                        ScrollView { profileView }
                    } else {
                        searchView
                    }
                }

                if showMenu {
                    SideMenuView(
                        onClose: { showMenu = false },
                        onNavigateConnections: {
                            showMenu = false
                            navigateToConnections = true
                        },
                        onLogout: {
                            showMenu = false
                            isLoggedIn = false
                            didCompleteOnboarding = false
                        }
                    )
                }
            }
            .navigationDestination(isPresented: $navigateToConnections) {
                ConnectionsMainView()
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .animation(.easeInOut, value: showMenu)
        .onAppear {
            refreshUserFromCurrentUser()
        }
    }

    private func refreshUserFromCurrentUser() {
        guard let user = CurrentUser.shared.user else { return }
        userName = user.name
        userEmail = user.email
        if let major = user.major?.major {
            userMajor = major
        }
        if let image = CurrentUser.shared.profileImage(for: user.id) {
            userImage = image
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        VStack(spacing: 0) {
            HStack {
                Button { showMenu = true } label: {
                    Image("3 rows")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.leading, 15)
                }

                Button { selectedTab = .profile } label: {
                    Image("person")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                        .foregroundColor(
                            selectedTab == .profile
                            ? Color(hex:0xF7798D)
                            : Color(hex:0xC2C2C2)
                        )
                        .padding(.leading, 30)
                }

                Spacer()

                Button { selectedTab = .search } label: {
                    Image("search")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                        .foregroundColor(
                            selectedTab == .search
                            ? Color(hex:0xF7798D)
                            : Color(hex:0xC2C2C2)
                        )
                        .padding(.leading, 35)
                }

                Spacer()
            }
            .padding(.top)
            .padding(.bottom, 12)

            HStack(spacing: 0) {
                Rectangle()
                    .fill(selectedTab == .profile ? Color(hex:0xF7798D) : .gray.opacity(0.4))
                    .frame(height: 4)

                Rectangle()
                    .fill(selectedTab == .search ? Color(hex:0xF7798D) : .gray.opacity(0.4))
                    .frame(height: 4)
            }
        }
        .background(Color.white)
    }

    // MARK: - Profile View

    var profileView: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .top, spacing: 30) {

                VStack(spacing: 14) {
                    if let userImage {
                        Image(uiImage: userImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Image("person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray.opacity(0.7))
                    }

                    NavigationLink {
                        EditProfileView(
                            name: userName,
                            bio: userBio,
                            email: userEmail,
                            major: userMajor,
                            selectedImage: userImage
                        ) { newName, newBio, newEmail, newMajor, newImage in
                            userName = newName
                            userBio = newBio
                            userEmail = newEmail
                            userMajor = newMajor
                            userImage = newImage

                            if let id = CurrentUser.shared.user?.id {
                                CurrentUser.shared.setProfileImage(newImage, for: id)
                            }
                        }
                    } label: {
                        Text("Edit Profile")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color(hex:0xF7798D))
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                }
                .padding(.top, 20)

                VStack(alignment: .leading, spacing: 10) {
                    Text(userName)
                        .font(.system(size: 20))
                        .fontWeight(.medium)

                    Text(userEmail)
                        .foregroundColor(.gray)

                    Text(userMajor)
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 30)

            MyScheduleView()

            NavigationLink {
                ClassSearchView()
            } label: {
                Text("Add classes")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex:0xF7798D))
                    .cornerRadius(20)
                    .padding(.horizontal, 40)
            }
            .padding(.top, 35)

            Spacer(minLength: 30)
        }
    }

    // MARK: - Search

    var filteredStudents: [SearchStudent] {
        allStudents.filter { student in
            guard !searchCourse.isEmpty else { return false }
            return student.courses.contains { $0.localizedCaseInsensitiveContains(searchCourse) }
        }
    }

    var searchView: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)

                TextField("Enter course number", text: $searchCourse)
                    .foregroundColor(.white)
                    .textInputAutocapitalization(.characters)

                if !searchCourse.isEmpty {
                    Button { searchCourse = "" } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.4))
            .cornerRadius(30)
            .padding(.horizontal, 20)
            .padding(.top, 20)

            ScrollView {
                VStack(spacing: 0) {

                    let filtered = filteredStudents

                    if searchCourse.isEmpty {
                        Text("Search for a course to see students")
                            .foregroundColor(.gray)
                            .padding(.top, 30)
                            .padding(.leading, 40)
                    }
                    else if filtered.isEmpty {
                        Text("No students found")
                            .foregroundColor(.gray)
                            .padding(.top, 30)
                    }
                    else {
                        ForEach(filtered) { student in
                            HStack {
                                Circle()
                                    .fill(Color(hex: 0xF7AFC2))
                                    .frame(width: 50, height: 50)
                                    .overlay(Text(student.name.prefix(1)))

                                VStack(alignment: .leading) {
                                    Text(student.name)
                                        .font(.headline)
                                    Text(student.email)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)

                            Divider()
                                .padding(.leading, 20)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 10)
        }
    }
}

#Preview {
    ContentView(isLoggedIn: .constant(true), didCompleteOnboarding: .constant(true))
}
