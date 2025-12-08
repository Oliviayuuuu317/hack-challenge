//
//  WelcomeFlowView.swift
//  HackChallenge
//
//  Created by Ben Chen on 12/5/25.
//

import SwiftUI
import PhotosUI

// MARK: - Static lists

let majors_list = [
    "Agricultural Sciences", "Animal Science", "Anthropology",
    "Applied Economics and Management", "Archaeology", "Architecture",
    "Asian Studies", "Astronomy", "Atmospheric Science",
    "Biological Engineering", "Biological Sciences", "Biology and Society",
    "Biomedical Engineering", "Biometry and Statistics", "Chemical Engineering",
    "Chemistry", "China and Asia-Pacific Studies", "Civil Engineering",
    "Classics", "Cognitive Science", "College Scholar",
    "Communication", "Comparative Literature", "Computer Science",
    "Design and Environmental Analysis", "Earth and Atmospheric Sciences",
    "Economics", "Electrical and Computer Engineering",
    "Engineering Physics", "English", "Entomology",
    "Environment and Sustainability", "Environmental Engineering",
    "Fashion Design and Management", "Fiber Science", "Fine Arts",
    "Food Science", "French", "German Studies",
    "Global and Public Health Sciences", "Global Development", "Government",
    "History", "Hotel Administration", "Human Biology, Health, and Society",
    "Human Development", "Information Science", "Landscape Architecture",
    "Linguistics", "Materials Science and Engineering", "Mathematics",
    "Mechanical Engineering", "Music", "Nutritional Sciences",
    "Operations Research and Engineering", "Performing and Media Arts",
    "Philosophy", "Physics", "Plant Sciences", "Psychology",
    "Public Policy", "Religious Studies", "Sociology",
    "Spanish", "Statistical Science", "Undecided",
    "Urban and Regional Studies"
]

let categories_list: [String: [String]] = [
    "Music": ["Pop", "Rock", "Jazz", "Classical", "Hip-hop", "Electronic",
              "Guitar", "Piano", "Drums", "Violin", "Saxophone"],
    "Sports": ["Soccer", "Basketball", "Tennis", "Running", "Swimming", "Rock Climbing"],
    "Reading": ["Fiction", "Non-fiction", "Science Fiction", "Fantasy", "Comics", "Poetry"],
    "Games": ["Video Games", "Board Games", "Card Games", "Tabletop RPG", "Chess"],
    "Outdoors": ["Hiking", "Camping", "Bird Watching", "Gardening", "Surfing"],
    "Food": ["Cooking", "Baking", "Wine Tasting", "Coffee", "Tea", "Beer Brewing"],
    "Art": ["Painting", "Sculpting", "Photography", "Drawing", "Knitting", "Sewing"],
    "Tech": ["Programming", "Robotics", "Astronomy", "AI", "Electronics"]
]

// MARK: - ROOT ONBOARDING FLOW

struct OnboardingFlowView: View {
    @Binding var didCompleteOnboarding: Bool
    @State private var profileImage: UIImage? = nil

    var body: some View {
        NavigationStack {
            ProfilePhotoScreen(
                profileImage: $profileImage,
                didCompleteOnboarding: $didCompleteOnboarding
            )
        }
    }
}

// MARK: - SCREEN 1: Profile Photo

struct ProfilePhotoScreen: View {

    @Binding var profileImage: UIImage?
    @Binding var didCompleteOnboarding: Bool

    @State private var showPicker = false
    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 30) {
                Spacer().frame(height: 40)

                Text("Add a Profile Photo")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)

                Group {
                    if let img = profileImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 180, height: 180)
                            .clipShape(Circle())
                            .shadow(radius: 6)
                    } else {
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 180, height: 180)
                            .overlay(
                                Image(systemName: "person.crop.circle")
                                    .font(.system(size: 80))
                                    .foregroundColor(.white.opacity(0.8))
                            )
                    }
                }

                Button("Upload Photo") {
                    showPicker = true
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(hex: 0xF7798D))
                .cornerRadius(16)
                .padding(.horizontal, 40)

                NavigationLink {
                    MajorSelectionScreen(
                        profileImage: profileImage,
                        didCompleteOnboarding: $didCompleteOnboarding
                    )
                } label: {
                    PinkNextButton(text: "Next >")
                }
                .padding(.horizontal, 40)

                NavigationLink {
                    MajorSelectionScreen(
                        profileImage: profileImage,
                        didCompleteOnboarding: $didCompleteOnboarding
                    )
                } label: {
                    Text("Skip for now")
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()
            }
        }
        .photosPicker(isPresented: $showPicker, selection: $selectedItem)
        .onChange(of: selectedItem) { _, newItem in
            guard let item = newItem else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    // Update local state
                    profileImage = uiImage

                    // Persist to CurrentUser if we have a logged-in user
                    if let userID = CurrentUser.shared.user?.id {
                        CurrentUser.shared.setProfileImage(uiImage, for: userID)
                    }
                }
            }
        }
    }
}

// MARK: - SCREEN 2: Major Selection

struct MajorSelectionScreen: View {

    var profileImage: UIImage?
    @Binding var didCompleteOnboarding: Bool

    @State private var selectedMajor = ""
    @State private var showDropdown = false

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 30) {
                Spacer().frame(height: 60)

                Text("Choose Your Major")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)

                VStack(spacing: 0) {
                    Button {
                        withAnimation { showDropdown.toggle() }
                    } label: {
                        dropdownLabel(text: selectedMajor.isEmpty ? "Select Major" : selectedMajor)
                    }

                    if showDropdown {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(majors_list, id: \.self) { major in
                                    Text(major)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.white.opacity(0.9))
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            selectedMajor = major
                                            withAnimation { showDropdown = false }
                                        }
                                }
                            }
                        }
                        .frame(height: 250)
                    }
                }
                .padding(.horizontal, 40)

                Spacer()

                NavigationLink {
                    InterestCategoryScreen(
                        profileImage: profileImage,
                        selectedMajor: selectedMajor,
                        didCompleteOnboarding: $didCompleteOnboarding
                    )
                } label: {
                    PinkNextButton(text: "Next >")
                }
                .padding(.horizontal, 40)
                .disabled(selectedMajor.isEmpty)
                .opacity(selectedMajor.isEmpty ? 0.5 : 1)

                Spacer()
            }
        }
    }

    func dropdownLabel(text: String) -> some View {
        HStack {
            Text(text)
                .foregroundColor(text.contains("Select") ? .gray : .black)
            Spacer()
            Image(systemName: "chevron.down")
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(radius: 3)
    }
}

// MARK: - SCREEN 3: Interests

struct InterestCategoryScreen: View {

    var profileImage: UIImage?
    var selectedMajor: String

    @Binding var didCompleteOnboarding: Bool

    @State private var selectedCategory = ""
    @State private var selectedInterests: [String] = []

    let categories = Array(categories_list.keys).sorted()

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 25) {
                Spacer().frame(height: 50)

                Text("Select Your Interests")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)

                Menu {
                    ForEach(categories, id: \.self) { cat in
                        Button(cat) { selectedCategory = cat }
                    }
                } label: {
                    dropdownLabel(text: selectedCategory.isEmpty ? "Choose Category" : selectedCategory)
                }

                if !selectedCategory.isEmpty {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(categories_list[selectedCategory]!, id: \.self) { interest in
                                interestToggle(interest)
                            }
                        }
                    }
                    .frame(maxHeight: 300)
                }

                Spacer()

                Button {
                    guard let user = CurrentUser.shared.user else {
                        print("No logged-in user found")
                        return
                    }

                    let interestInputs = selectedInterests.map { name in
                        InterestInput(name: name, category: categoryOf(name))
                    }

                    NetworkManager.shared.updateUser(
                        userID: user.id,
                        major: selectedMajor,
                        interests: interestInputs
                    ) { updatedUser in

                        if let updatedUser = updatedUser {
                            print("Updated user:", updatedUser)
                            CurrentUser.shared.user = updatedUser
                            didCompleteOnboarding = true
                        } else {
                            print("Update failed")
                        }
                    }
                } label: {
                    PinkNextButton(text: "Finish")
                }
                .disabled(selectedInterests.isEmpty)
                .opacity(selectedInterests.isEmpty ? 0.5 : 1)

                Spacer()
            }
            .padding(.horizontal, 40)
        }
    }

    // Find category for an interest
    func categoryOf(_ interest: String) -> String {
        for (category, items) in categories_list {
            if items.contains(interest) {
                return category
            }
        }
        return "Unknown"
    }

    func dropdownLabel(text: String) -> some View {
        HStack {
            Text(text)
                .foregroundColor(text.contains("Choose") ? .gray : .black)
            Spacer()
            Image(systemName: "chevron.down")
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(radius: 2)
    }

    func interestToggle(_ interest: String) -> some View {
        HStack {
            Text(interest)
            Spacer()
            if selectedInterests.contains(interest) {
                Image(systemName: "checkmark.circle.fill").foregroundColor(.pink)
            }
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(10)
        .onTapGesture {
            if selectedInterests.contains(interest) {
                selectedInterests.removeAll { $0 == interest }
            } else {
                selectedInterests.append(interest)
            }
        }
    }
}

// MARK: - Shared Components

struct PinkNextButton: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(hex: 0xF7798D))
            .cornerRadius(16)
            .shadow(radius: 3)
    }
}

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >>  8) & 0xff) / 255,
            blue: Double((hex      ) & 0xff) / 255
        )
    }
}

#Preview {
    OnboardingFlowView(didCompleteOnboarding: .constant(false))
}
