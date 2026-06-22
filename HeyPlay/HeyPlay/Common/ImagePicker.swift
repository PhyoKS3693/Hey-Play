//
//  ImagePicker.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 06/15/26.
//

import SwiftUI
import UIKit
import PhotosUI
import Photos

// MARK: - Image Picker Source Type
enum ImagePickerSourceType {
    case camera
    case photoLibrary
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    var sourceType: ImagePickerSourceType

    func makeUIViewController(context: Context) -> UIImagePickerController {
        print("🎯 [ImagePicker] makeUIViewController called with sourceType: \(sourceType)")
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true

        switch sourceType {
        case .camera:
            print("📸 [ImagePicker] Setting up camera source")
            picker.sourceType = .camera
        case .photoLibrary:
            print("📚 [ImagePicker] Setting up photo library source")
            picker.sourceType = .photoLibrary
        }

        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            print("✅ [ImagePicker] Image picked successfully")
            if let editedImage = info[.editedImage] as? UIImage {
                print("📷 [ImagePicker] Using edited image")
                parent.selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                print("📷 [ImagePicker] Using original image")
                parent.selectedImage = originalImage
            }

            parent.isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            print("❌ [ImagePicker] Image picker cancelled")
            parent.isPresented = false
        }
    }
}

// MARK: - Image Picker Action Sheet
struct ImagePickerActionSheet: View {
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage?
    @Binding var showCamera: Bool
    @Binding var showPhotoLibrary: Bool

    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }

            VStack {
                Spacer()

                VStack(spacing: 0) {
                    Text("Select Profile Photo")
                        .font(FontUtility.heading2())
                        .foregroundColor(.white)
                        .padding(.vertical, 20)

                    Divider()
                        .background(Color.white.opacity(0.3))

                    Button(action: {
                        print("📷 [ImagePickerActionSheet] Camera button tapped")
                        // Check camera availability
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            print("✅ [ImagePickerActionSheet] Camera available, triggering camera picker")
                            isPresented = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                showCamera = true
                            }
                        } else {
                            print("❌ [ImagePickerActionSheet] Camera not available on this device")
                            isPresented = false
                        }
                    }) {
                        HStack {
                            Image(systemName: "camera.fill")
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)

                            Text("Take Photo")
                                .font(FontUtility.body1())
                                .foregroundColor(.white)

                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }

                    Divider()
                        .background(Color.white.opacity(0.3))

                    Button(action: {
                        print("🖼️ [ImagePickerActionSheet] Photo Library button tapped")
                        isPresented = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            showPhotoLibrary = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "photo.fill")
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)

                            Text("Choose from Library")
                                .font(FontUtility.body1())
                                .foregroundColor(.white)

                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }

                    Divider()
                        .background(Color.white.opacity(0.3))

                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Cancel")
                            .font(FontUtility.body1())
                            .foregroundColor(Color("pink_Color"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                }
                .background(Color(red: 28/255, green: 28/255, blue: 30/255))
                .cornerRadius(20)
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }
}
