//
//  dailyLogueViewController.swift
//  selflogue
//
//  Created by Chew Jun Pin on 4/5/2023.
//

import UIKit
import Photos

class DailyLogueViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    let imageView = UIImageView()
    let saveImageButton = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Customize the appearance of the UIImageView
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        // Add constraints for the UIImageView
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        let selectImageButton = UIButton(type: .system)
        selectImageButton.setTitle("Select Image", for: .normal)
        selectImageButton.addTarget(self, action: #selector(selectImageTapped), for: .touchUpInside)
        selectImageButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectImageButton)
        
        // Add constraints for the button
        NSLayoutConstraint.activate([
            selectImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectImageButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Customize and add constraints for the saveImageButton
        saveImageButton.setTitle("Save Image", for: .normal)
        saveImageButton.addTarget(self, action: #selector(saveImageTapped), for: .touchUpInside)
        saveImageButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveImageButton)
        
        NSLayoutConstraint.activate([
            saveImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveImageButton.topAnchor.constraint(equalTo: selectImageButton.bottomAnchor, constant: 20)
        ])
    }
    
    
//    @objc func saveImageTapped() {
//        guard let image = imageView.image, let data = image.jpegData(compressionQuality: 1) else { return }
//        let filename = getDocumentsDirectory().appendingPathComponent("\(UUID().uuidString).jpg")
//        do {
//            try data.write(to: filename)
//            print("Saved image to \(filename)")
//        } catch {
//            print("Failed to save image: \(error)")
//        }
//    }
    
    @objc func saveImageTapped() {
        guard let image = imageView.image else { return }

        // Get user's description for the image
        let alertController = UIAlertController(title: "Add description", message: "Enter a description for your image.", preferredStyle: .alert)
        alertController.addTextField()

        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alertController] _ in
            guard let self = self, let description = alertController?.textFields?.first?.text else { return }

            // Generate a unique name for the image
            let imageName = UUID().uuidString + ".png"
            let imagePath = self.getDocumentsDirectory().appendingPathComponent(imageName)

            // Save the image
            if let data = image.pngData() {
                try? data.write(to: imagePath)
            }

            // Save the description with the same name (minus the extension)
            let descriptionFileName = imageName.replacingOccurrences(of: ".png", with: "")
            let descriptionFilePath = self.getDocumentsDirectory().appendingPathComponent(descriptionFileName).appendingPathExtension("txt")
            try? description.write(to: descriptionFilePath, atomically: true, encoding: .utf8)
            
            // Reloading imageFiles after saving new image
            ImagesManager.shared.loadImageFiles()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    @objc func selectImageTapped() {
        showPhotoOptions()
    }

    
    func showPhotoOptions() {
        
        let alertController = UIAlertController(title: "Select Photo", message: "Choose a source", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    
    func openCamera() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available")
            return
        }

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true)
        
    }
    
    
    func openGallery() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
        
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
        }
        picker.dismiss(animated: true)
        
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }


}
