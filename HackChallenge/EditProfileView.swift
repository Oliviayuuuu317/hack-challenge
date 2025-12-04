//
//  EditProfileView.swift
//  HackChallenge
//
//  Created by Ben Chen on 12/3/25.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss

    @State var name: String
    @State var bio: String
    @State var major: String
    @State var selectedImage: UIImage?

    var onSave: (String, String, String, UIImage?) -> Void

    // Image picker
    @State private var showPhotoPicker = false
    @State private var photoItem: PhotosPickerItem?

    var body: some View {
        VStack(spacing: 24) {

            // Profile Image
            VStack {
                if let selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .onTapGesture { showPhotoPicker = true }
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                        .onTapGesture { showPhotoPicker = true }
                }
            }
            .padding(.top, 40)

            Text(name)
                .font(.system(size: 22, weight: .semibold))

            Text(bio)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            VStack(alignment: .leading, spacing: 8) {
                Text("Major")
                    .font(.system(size: 16))

                TextField("Enter major", text: $major)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 4)
            }
            .padding(.horizontal, 40)

            Spacer()

            Button(action: {
                onSave(name, bio, major, selectedImage)
            }) {
                Text("Save")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex:0xF7798D))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 30)
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $photoItem)
        .onChange(of: photoItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                }
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}
