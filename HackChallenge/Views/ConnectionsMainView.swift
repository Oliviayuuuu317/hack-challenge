//
//  ConnectionsMainView.swift
//  HackChallenge
//
//  Created by Ben Chen on 12/5/25.
//

import SwiftUI

struct ConnectionsMainView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Top segmented bar
            HStack {
                SegmentButton(title: "Connections", index: 0, selected: $selectedTab)
                SegmentButton(title: "Requests", index: 1, selected: $selectedTab)
                SegmentButton(title: "Requested", index: 2, selected: $selectedTab)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Divider()
            
            // Content
            if selectedTab == 0 {
                ConnectionsView()
            } else if selectedTab == 1 {
                RequestsView()
            } else {
                RequestedView()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SegmentButton: View {
    let title: String
    let index: Int
    @Binding var selected: Int
    
    var body: some View {
        Button {
            selected = index
        } label: {
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: selected == index ? .bold : .regular))
                    .foregroundColor(selected == index ? Color(hex: 0xF7798D) : .gray)
                
                Rectangle()
                    .fill(selected == index ? Color(hex: 0xF7798D) : Color.clear)
                    .frame(height: 3)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct ConnectionsView: View {
    @State private var searchText = ""
    
    @State private var connections: [UserConnection] = [
        UserConnection(id: 1, name: "Mr. Eggplant", email: "eggplant@cornell.edu"),
        UserConnection(id: 2, name: "Walter White", email: "abcdefg@cornell.edu")
    ]
    
    @State private var toRemove: UserConnection? = nil
    
    var body: some View {
        VStack {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.white)
                TextField("Search", text: $searchText)
                    .foregroundColor(.white)
                
                if !searchText.isEmpty {
                    Button { searchText = "" } label: {
                        Image(systemName: "xmark").foregroundColor(.white)
                    }
                }
            }
            .padding()
            .background(Color(hex: 0xF7AFC2))
            .cornerRadius(30)
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            // Filtered connections
            let filtered = connections.filter {
                searchText.isEmpty ||
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
            
            if filtered.isEmpty {
                Spacer()
                Text("You have no current connections")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List(filtered) { user in
                    HStack {
                        Circle()
                            .fill(Color(hex: 0xF7AFC2))
                            .frame(width: 50, height: 50)
                            .overlay(Text(user.name.prefix(1)))
                        
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.headline)
                            Text(user.email)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button {
                            toRemove = user
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .padding(.trailing, 6)
                        }
                    }
                    .padding(.vertical, 6)
                }
                .listStyle(.plain)
            }
        }
        .overlay(removePopup)
    }
    
    @ViewBuilder
    var removePopup: some View {
        if let user = toRemove {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { toRemove = nil }
            
            VStack(spacing: 16) {
                Circle()
                    .fill(Color(hex: 0xF7AFC2))
                    .frame(width: 60, height: 60)
                    .overlay(Text(user.name.prefix(1)))
                
                Text("Remove \(user.name)?")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Button {
                    connections.removeAll { $0.id == user.id }
                    toRemove = nil
                } label: {
                    Text("Remove")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: 0xF7798D))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                Button {
                    toRemove = nil
                } label: {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                }
            }
            .padding()
            .frame(width: 300)
            .background(Color.white)
            .cornerRadius(20)
        }
    }
}

struct UserConnection: Identifiable {
    let id: Int
    let name: String
    let email: String
}

struct RequestsView: View {
    @State private var requests: [UserConnection] = [
        UserConnection(id: 3, name: "John Smith", email: "jsmith@cornell.edu"),
        UserConnection(id: 4, name: "Gojo Satoru", email: "halfman@cornell.edu")
    ]
    
    var body: some View {
        List {
            ForEach(requests) { user in
                HStack {
                    Circle()
                        .fill(Color(hex: 0xF7AFC2))
                        .frame(width: 50, height: 50)
                        .overlay(Text(user.name.prefix(1)))
                    
                    VStack(alignment: .leading) {
                        Text(user.name).font(.headline)
                        Text(user.email).font(.caption).foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Button("Accept") {
                        requests.removeAll { $0.id == user.id }
                    }
                    .padding(6)
                    .background(Color.green.opacity(0.5))
                    .cornerRadius(8)
                    
                    Button("Decline") {
                        requests.removeAll { $0.id == user.id }
                    }
                    .padding(6)
                    .background(Color.red.opacity(0.5))
                    .cornerRadius(8)
                }
                .padding(.vertical, 6)
            }
        }
        .listStyle(.plain)
    }
}

struct RequestedView: View {
    @State private var outgoing: [UserConnection] = [
        UserConnection(id: 5, name: "Professor Bean", email: "bean@cornell.edu")
    ]
    
    var body: some View {
        List {
            ForEach(outgoing) { user in
                HStack {
                    Circle()
                        .fill(Color(hex: 0xF7AFC2))
                        .frame(width: 50, height: 50)
                        .overlay(Text(user.name.prefix(1)))
                    
                    VStack(alignment: .leading) {
                        Text(user.name)
                        Text(user.email)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text("Pending")
                        .foregroundColor(.gray)
                }
            }
        }
        .listStyle(.plain)
    }
}
