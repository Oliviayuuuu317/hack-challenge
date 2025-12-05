import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss

    // Editable fields
    @State var name: String
    @State var bio: String
    @State var email: String
    @State var major: String
    @State var selectedImage: UIImage?

    // Callback to return updated values
    var onSave: (String, String, String, String, UIImage?) -> Void

    // Photo picker
    @State private var showPhotoPicker = false
    @State private var photoItem: PhotosPickerItem?

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // MARK: - Profile Image
                VStack {
                    if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .onTapGesture { showPhotoPicker = true }
                    } else {
                        Image("person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray.opacity(0.7))
                            .onTapGesture { showPhotoPicker = true }
                    }
                }
                .padding(.top, 40)

                // MARK: - Name Field
                VStack(alignment: .leading, spacing: 6) {
                    Text("Name")
                        .font(.system(size: 16, weight: .medium))
                    TextField("Enter your name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal, 40)

                // MARK: - Bio Field
                VStack(alignment: .leading, spacing: 6) {
                    Text("Bio")
                        .font(.system(size: 16, weight: .medium))
                    TextField("Enter your bio", text: $bio)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal, 40)

                // MARK: - Email Field
                VStack(alignment: .leading, spacing: 6) {
                    Text("Email")
                        .font(.system(size: 16, weight: .medium))
                    TextField("Enter your email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                .padding(.horizontal, 40)

                // MARK: - Major Field
                VStack(alignment: .leading, spacing: 6) {
                    Text("Major")
                        .font(.system(size: 16, weight: .medium))
                    TextField("Enter major", text: $major)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal, 40)

                Spacer()

                // MARK: - Save Button
                Button(action: {
                    onSave(name, bio, email, major, selectedImage)
                    dismiss()
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 247/255, green: 121/255, blue: 141/255))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
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
