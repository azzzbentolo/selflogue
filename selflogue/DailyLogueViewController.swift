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

        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
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
        
        NSLayoutConstraint.activate([
            selectImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectImageButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
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

        let alertController = UIAlertController(title: "Add description", message: "Enter a description for your image.", preferredStyle: .alert)
        alertController.addTextField()

        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alertController] _ in
            guard let self = self, let description = alertController?.textFields?.first?.text else { return }

            let timestamp = Date()
            let imageName = "\(Int(timestamp.timeIntervalSince1970)).png"
            let imagePath = self.getDocumentsDirectory().appendingPathComponent(imageName)

            if let data = image.pngData() {
                try? data.write(to: imagePath)
            }

            let descriptionFileName = imageName.replacingOccurrences(of: ".png", with: "")
            let descriptionFilePath = self.getDocumentsDirectory().appendingPathComponent(descriptionFileName).appendingPathExtension("txt")
            let timestampString = format(date: timestamp) // Convert timestamp to string
            let descriptionAndTimestamp = "\(description)\n\(timestampString)" // Store the description and timestamp
            try? descriptionAndTimestamp.write(to: descriptionFilePath, atomically: true, encoding: .utf8)

            ImagesManager.shared.loadImageFiles()

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
        present(imagePickerController, animated: true)
        
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        picker.dismiss(animated: true) {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let cropViewController = TOCropViewController(image: pickedImage)
                cropViewController.delegate = self
                cropViewController.customAspectRatio = CGSize(width: 1, height: 1)
                cropViewController.aspectRatioLockEnabled = true
                cropViewController.resetAspectRatioEnabled = false
                cropViewController.cropView.cropBoxResizeEnabled = true
                self.present(cropViewController, animated: true, completion: nil)
            }
        }
        
    }


    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        
        imageView.image = image
        cropViewController.dismiss(animated: true, completion: nil)
        
    }
    
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

}
