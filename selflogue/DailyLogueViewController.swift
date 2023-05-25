//
//  dailyLogueViewController.swift
//  selflogue
//
//  Created by Chew Jun Pin on 4/5/2023.
//

import UIKit
import Photos
import TOCropViewController

class DailyLogueViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
    
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
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(pinchGesture)

    }

    
    @objc func saveImageTapped() {
        guard let image = imageView.image else { return }

        // Get user's description for the image
        let alertController = UIAlertController(title: "Add description", message: "Enter a description for your image.", preferredStyle: .alert)
        alertController.addTextField()

        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alertController] _ in
            guard let self = self, let description = alertController?.textFields?.first?.text else { return }

            // Generate a unique name for the image based on the current timestamp
            let timestamp = Int(Date().timeIntervalSince1970)
            let imageName = "\(timestamp).png"
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

            // Clear the imageView
            self.imageView.image = nil
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }


    
    
    @objc func handlePinch(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            gesture.view?.transform = (gesture.view?.transform.scaledBy(x: gesture.scale, y: gesture.scale))!
            gesture.scale = 1
        }
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
        imagePickerController.allowsEditing = true // Add this line
        present(imagePickerController, animated: true)
        
    }
    

    func openGallery() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
//        imagePickerController.allowsEditing = true // Add this line
        present(imagePickerController, animated: true)
        
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let cropViewController = TOCropViewController(image: pickedImage)
                cropViewController.delegate = self
                cropViewController.customAspectRatio = CGSize(width: 1, height: 1) //Set the initial aspect ratio as a square
                cropViewController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
                cropViewController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will be reset to the default one
                cropViewController.cropView.cropBoxResizeEnabled = true // User can change aspect ratio
                self.present(cropViewController, animated: true, completion: nil)
            }
        }
    }

    
    // Implement the delegate methods of TOCropViewController
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        // Assign the cropped image to your image view and dismiss the controller
        imageView.image = image
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        // Handle cancel
        cropViewController.dismiss(animated: true, completion: nil)
    }
    

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }


}
