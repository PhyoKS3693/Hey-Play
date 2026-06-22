//
//  ProfileScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI
import Kingfisher

struct ProfileScreen: View {
    var host: HostController?

    var didTapBack: (() -> Void)?

    @ObservedObject private var viewModel: ProfileViewModel
    @ObservedObject private var errorManager = ErrorManager.shared
    @State private var editedName: String = ""
    @State private var editedEmail: String = ""
    @State private var showImagePickerActionSheet = false
    @State private var selectedImage: UIImage?
    @State private var showCamera = false
    @State private var showPhotoLibrary = false

    init(_ viewModel: ProfileViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        if #available(iOS 15.0, *) {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        navView()
                        
                        HStack {
                            Spacer()

                            Button(action: {
                                print("👤 [ProfileScreen] Profile image tapped, showing action sheet")
                                showImagePickerActionSheet = true
                            }) {
                                ZStack(alignment: .bottomTrailing) {
                                    // Display selected image, profile image, or default
                                    if let selectedImage = selectedImage {
                                        Image(uiImage: selectedImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipShape(Circle())
                                    } else if let profileImageURL = viewModel.profileImageURL,
                                              let url = URL(string: profileImageURL) {
                                        KFImage(url)
                                            .placeholder {
                                                Image("ic-user")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 80, height: 80)
                                            }
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipShape(Circle())
                                    } else {
                                        Image("ic-user")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                    }

                                    // Camera icon overlay
                                    Image("ic_camera")
                                        .frame(width: 26, height: 26)
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                }
                            }

                            Spacer()
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Name")
                                .font(FontUtility.caption())
                                .foregroundColor(Color.white)
                            
                            TextField("Enter your name", text: $editedName)
                                .padding(.horizontal, 20)
                                .frame(height: 40)
                                .frame(maxWidth: .infinity)
                                .background(Color.black)
                                .font(FontUtility.body1())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                                .foregroundColor(.white)
                        }
                        .padding(10)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Account")
                                    .font(FontUtility.caption())
                                    .foregroundColor(Color("white_color"))

                                Text("(Optional)")
                                    .font(FontUtility.caption())
                                    .foregroundColor(Color("castType"))
                            }

                            TextField("Enter your email (optional)", text: $editedEmail)
                                .padding(.horizontal, 20)
                                .frame(height: 40)
                                .frame(maxWidth: .infinity)
                                .background(Color.black)
                                .font(FontUtility.body1())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                                .foregroundColor(.white)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disabled(true)  // Disable editing
                        }
                        .padding(10)
                        
                        Text("Linked Accounts")
                            .font(FontUtility.headline2())
                            .foregroundColor(Color.white)
                            .padding(.vertical, 10)
                        
                        renderLinkedAccount("ic.facebook", "Facebook", "www.facebook.com")
                        
                        renderLinkedAccount("ic.apple", "Apple", nil)
                        
                        renderLinkedAccount("ic.google", "Google", "www.google.com")
                        
                        renderLinkedAccount("ic.line", "Line", nil)

                        Spacer()
                            .frame(height: 80)
                    }
                    .padding(.bottom, 80)
                }
                
                // Save Button at bottom
                VStack {
                    Spacer()
                    
                    Button(action: {
                        // Convert selected image to base64 if available
                        var profileImageBase64: String? = nil
                        if let selectedImage = selectedImage {
                            profileImageBase64 = viewModel.convertImageToBase64(selectedImage)
                        }

                        viewModel.updateProfile(
                            name: editedName,
                            email: editedEmail,
                            profileImage: profileImageBase64
                        )
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Save")
                                .font(FontUtility.body1())
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(viewModel.isLoading ? Color.gray : Color("pink_Color"))
                    .cornerRadius(25)
                    .disabled(viewModel.isLoading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }

                // Image Picker Action Sheet
                if showImagePickerActionSheet {
                    ImagePickerActionSheet(
                        isPresented: $showImagePickerActionSheet,
                        selectedImage: $selectedImage,
                        showCamera: $showCamera,
                        showPhotoLibrary: $showPhotoLibrary
                    )
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $showCamera) {
                ImagePicker(selectedImage: $selectedImage, isPresented: $showCamera, sourceType: .camera)
            }
            .sheet(isPresented: $showPhotoLibrary) {
                ImagePicker(selectedImage: $selectedImage, isPresented: $showPhotoLibrary, sourceType: .photoLibrary)
            }
            .errorDialog($errorManager.currentError)
            .onChange(of: viewModel.errorMessage) { error in
                if let errorMsg = error {
                    ErrorManager.shared.showError(title: "Error", message: errorMsg)
                    viewModel.errorMessage = nil
                }
            }
            .onAppear {
                viewModel.fetchProfile()
                // Initialize editable fields with current profile data
                editedName = viewModel.profile?.name ?? ""
                editedEmail = viewModel.profile?.account ?? ""
            }
            .onChange(of: viewModel.profile) { newProfile in
                // Update fields when profile data loads
                if editedName.isEmpty {
                    editedName = newProfile?.name ?? ""
                }
                if editedEmail.isEmpty {
                    editedEmail = newProfile?.account ?? ""
                }
            }
            .onChange(of: selectedImage) { newImage in
                if newImage != nil {
                    print("✅ [ProfileScreen] Image selected successfully")
                }
            }
            .onChange(of: showCamera) { value in
                print("📸 [ProfileScreen] showCamera changed to: \(value)")
            }
            .onChange(of: showPhotoLibrary) { value in
                print("📚 [ProfileScreen] showPhotoLibrary changed to: \(value)")
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func navView() -> some View {
        ZStack (alignment: .leading){
            Button{
                didTapBack?()
            } label: {
                Image("ic.backBtn")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }
            
            HStack {
                
                
                Spacer()
                
                Text("Profile")
                    .font(FontUtility.heading1())
                    .foregroundColor(Color("white_color"))
                
                Spacer()
            }
        }
        .padding(10)
    }
    
    private func renderLinkedAccount(_ icon: String,_ name: String,_ url :String?) -> some View {
        Button{
            print()
        } label: {
            HStack {
                Image(icon)
                    .frame(width: 20, height: 20)
                    .padding(8)
                
                VStack (alignment: .leading) {
                    Text(name)
                        .font(FontUtility.caption())
                        .foregroundColor(.white)
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                    
                    if url != nil {
                        Text(url ?? "")
                            .font(FontUtility.body1())
                            .foregroundColor(.white)
                            .padding(.bottom, 8)
                    }
                }
                
                Spacer()
                
                if url != nil {
                    Image("ic-delete")
                        .frame(width: 20, height: 20)
                        .padding(8)
                }else {
                    Image("btn_add")
                        .frame(width: 69, height: 26)
                        .padding(8)
                }
            }
        }
        .padding(.horizontal, 20)
        .background(Color.black)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white, lineWidth: 1)
        )
        .foregroundColor(.white)
    }
}

#Preview {
    ProfileScreen(.init())
}
