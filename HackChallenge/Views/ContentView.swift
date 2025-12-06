//
//  ContentView.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang  on 11/30/25.
//

import SwiftUI

enum TopTab {
    case profile
    case search
}

struct ContentView: View {
    
    @State private var selectedTab: TopTab = .profile
    @State private var userBio = "Hi, I'm Jack!"
    @State private var userName = "Jack Nguyen"
    @State private var userEmail = "hn365@cornell.edu"
    @State private var userMajor = "CS"
    @State private var userImage: UIImage? = nil
    @State private var navigateToConnections = false
    
    @State private var showMenu = false

    var body: some View {
        ZStack {

            NavigationStack {
                VStack(spacing: 0) {
                    
                    // TOP BAR
                    HStack {
                        Button {
                            showMenu = true
                        } label: {
                            Image("3 rows")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.leading, 15)
                        }
                        
                        Button {
                            selectedTab = .profile
                        } label: {
                            Image("person")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                                .foregroundColor(selectedTab == .profile ? Color(hex:0xF7798D) : Color(hex:0xC2C2C2))
                                .padding(.leading, 30)
                        }
                        
                        Spacer()
                        
                        Button {
                            selectedTab = .search
                        } label: {
                            Image("search")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                                .foregroundColor(selectedTab == .search ? Color(hex:0xF7798D) : Color(hex:0xC2C2C2))
                                .padding(.leading, 35)
                        }
                        
                        Spacer()
                    }
                    .padding(.top)
                    .padding(.bottom, 12)
                    
                    // TAB BAR
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(selectedTab == .profile ? Color(hex:0xF7798D) : Color.gray.opacity(0.4))
                            .frame(height: 4)
                            .frame(maxWidth: .infinity)
                        
                        Rectangle()
                            .fill(selectedTab == .search ? Color(hex:0xF7798D) : Color.gray.opacity(0.4))
                            .frame(height: 4)
                            .frame(maxWidth: .infinity)
                    }
                    
                    ScrollView {
                        if selectedTab == .profile {
                            profileView
                        } else {
                            searchView
                        }
                    }
                }
                .navigationDestination(isPresented: $navigateToConnections) {
                    ConnectionsMainView()
                }
            }
            if showMenu {
                SideMenuView(
                    onClose: { showMenu = false },
                    onNavigateConnections: {
                        showMenu = false
                        navigateToConnections = true
                    }
                )
            }
        }
        .animation(.easeInOut, value: showMenu)
    }
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
                .padding(.top,20)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Text(userName)
                            .font(.system(size: 20))
                            .fontWeight(.medium)
                    }
                    
                    Text(userEmail)
                        .foregroundColor(.gray)
                    
                    Text(userMajor)
                        .foregroundColor(.gray)
                }

                .padding(.top,20)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 30)
            
//            Text("My schedule")
//                .font(.system(size: 32, weight: .semibold))
//                .padding(.horizontal)
//
//            RoundedRectangle(cornerRadius: 20)
//                .stroke(Color.black, lineWidth: 3)
//                .frame(height: 250)
//                .padding(.horizontal,35)
//                .overlay(
//                    MyScheduleView()
//                )
            MyScheduleView()
            
            NavigationLink {
                ConnectionsMainView()
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
            .padding(.top,35)
            
            Spacer(minLength: 30)
        }
    }
    
    var searchView: some View {
        VStack(spacing:20) {
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                
                Text("Enter course number")
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.gray.opacity(0.4))
            .cornerRadius(30)
            .padding(.horizontal, 20)
            
        }
        .padding(.top, 20)
    }
}

#Preview {
    ContentView()
}
