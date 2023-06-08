import Foundation
import TOCropViewController
import UIKit


class DailyLogueViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
    
    
    let imageView = UIImageView()
    let descriptionTextView = UITextView()
    let postButton = UIButton(type: .system)
    let cameraButton = UIButton(type: .system)
    let descriptionLabel = UILabel()
    let recordDayLabel = UILabel()
    let THEME_COL: UIColor = UIColor(red: 84, green: 65, blue: 177)
    let lightPurpleColor: UIColor = UIColor(red: 0.90, green: 0.75, blue: 0.98, alpha: 1.00)

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "What's Up?"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let subView = UIView()
        subView.backgroundColor = .white
        subView.layer.borderWidth = 3
        subView.layer.borderColor = THEME_COL.cgColor
        subView.layer.cornerRadius = 10
        subView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subView)
        
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -30),
            
            subView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            subView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            subView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15), // Adjust this constant as per your needs
            subView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
            
        ])
        
        recordDayLabel.text = "Record your day!"
        recordDayLabel.translatesAutoresizingMaskIntoConstraints = false
        subView.addSubview(recordDayLabel)
        
        NSLayoutConstraint.activate([
            recordDayLabel.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 30),
            recordDayLabel.topAnchor.constraint(equalTo: subView.topAnchor, constant: 30)
        ])
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = THEME_COL.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        subView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: recordDayLabel.bottomAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: subView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: subView.widthAnchor, multiplier: 0.65),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        cameraButton.setImage(UIImage(systemName: "camera"), for: .normal)
        cameraButton.tintColor = .black
        cameraButton.addTarget(self, action: #selector(selectImageTapped), for: .touchUpInside)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        subView.addSubview(cameraButton)
        
        NSLayoutConstraint.activate([
            cameraButton.centerXAnchor.constraint(equalTo: subView.centerXAnchor),
            cameraButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            cameraButton.widthAnchor.constraint(equalToConstant: 50),
            cameraButton.heightAnchor.constraint(equalTo: cameraButton.widthAnchor)
        ])
        
        descriptionLabel.text = "Description"
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        subView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 30), // Left-aligned
            descriptionLabel.topAnchor.constraint(equalTo: cameraButton.bottomAnchor, constant: 30)
        ])
        
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.cornerRadius = 5.0
        descriptionTextView.isScrollEnabled = true
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        subView.addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            descriptionTextView.centerXAnchor.constraint(equalTo: subView.centerXAnchor),
            descriptionTextView.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 130)
        ])
        
        postButton.setTitle("POST", for: .normal)
        postButton.backgroundColor = lightPurpleColor
        postButton.layer.cornerRadius = 5
        postButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        postButton.setTitleColor(THEME_COL, for: .normal)
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)

        subView.addSubview(postButton)
        
        NSLayoutConstraint.activate([
            postButton.centerXAnchor.constraint(equalTo: subView.centerXAnchor),
            postButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 30),
            postButton.widthAnchor.constraint(equalTo: subView.widthAnchor, multiplier: 0.2),
            postButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(pinchGesture)
    }
    
    
    @objc func saveImageTapped() {
        
        guard let image = imageView.image else { return }
        
        let timestamp = Date()
        let imageName = "\(Int(timestamp.timeIntervalSince1970)).png"
        let imagePath = self.getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let data = image.pngData() {
            try? data.write(to: imagePath)
        }
        
        let descriptionFileName = imageName.replacingOccurrences(of: ".png", with: "")
        let descriptionFilePath = self.getDocumentsDirectory().appendingPathComponent(descriptionFileName).appendingPathExtension("txt")
        let timestampString = format(date: timestamp)
        let descriptionAndTimestamp = "\(descriptionTextView.text ?? "")\n\(timestampString)"
        try? descriptionAndTimestamp.write(to: descriptionFilePath, atomically: true, encoding: .utf8)
        
        ImagesManager.shared.loadImageFiles()
        
        imageView.image = nil
        descriptionTextView.text = ""
    }
    
    
    @objc func postButtonTapped() {
        
        saveImageTapped()
        self.navigationController?.popViewController(animated: true)
        
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
        imagePickerController.allowsEditing = true
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

