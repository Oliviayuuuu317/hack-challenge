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
    
    @State private var userName = "Jack Nguyen"
    @State private var userBio = "hn365@cornell.edu"
    @State private var userMajor = "CS"
    @State private var userImage: UIImage? = nil

    
    var body: some View {
        NavigationStack {
            VStack(spacing:0) {

                HStack {
                    Spacer()
                    
                    Button {
                        selectedTab = .profile
                    } label: {
                        Image("person")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                            .foregroundColor(selectedTab == .profile ? Color(hex:0xF7798D) : Color(hex:0xC2C2C2))
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
                    }
                    
                    Spacer()
                }
                .padding(.top)
                .padding(.bottom, 12)
                

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
        }
    }
    
    

    var profileView: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            HStack(alignment: .top, spacing: 30) {
                
                VStack(spacing: 14) {
                    Image("person")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray.opacity(0.7))
                    NavigationLink {
                        EditProfileView(
                            name: userName,
                            bio: userBio,
                            major: userMajor,
                            selectedImage: userImage,
                            onSave: { newName, newBio, newMajor, newImage in
                                userName = newName
                                userBio = newBio
                                userMajor = newMajor
                                userImage = newImage
                            }
                        )
                    } label: {
                        Text("Edit profile")
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
                        Text("Jack Nguyen")
                            .font(.system(size: 20))
                            .fontWeight(.medium)
                        
                        Text("(he/him)")
                            .foregroundColor(.gray.opacity(0.6))
                            .font(.system(size: 14))
                            .baselineOffset(2)
                    }
                    
                    Text("hn365@cornell.edu")
                        .foregroundColor(.gray)
                    
                    Text("123-456-7890")
                        .foregroundColor(.gray)
                }
                .padding(.top,20)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 30)
            
            Text("My schedule")
                .font(.system(size: 32, weight: .semibold))
                .padding(.horizontal)
            
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 3)
                .frame(height: 250)
                .padding(.horizontal,35)
                .overlay(
                    Text("Calendar Placeholder")
                        .foregroundColor(.gray)
                )
            
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
