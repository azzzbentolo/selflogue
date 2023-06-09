import Foundation
import TOCropViewController
import UIKit


/// `DailyLogueViewController` is a UIKit view controller responsible for creating and posting a daily log. It integrates various UI elements and manages their interactions.
///
/// It follows the MVC (Model-View-Controller) architecture, where the view controller acts as the controller in the architecture. It manages the setup of the view hierarchy, handles user interactions, and interacts with the underlying data model.
///
/// The class utilizes the `UIImagePickerControllerDelegate` and` UINavigationControllerDelegate` protocols to handle image picking and cropping functionality.
///
/// The class demonstrates the principles of Object-Oriented Programming (OOP) as follows, because it encapsulates the setup and management of UI elements within its methods. It organizes the code and separates concerns by providing individual methods for specific tasks.
///
/// This class also abstracts away the complexity of handling user interactions and managing image picking and cropping functionality. It provides a simplified interface for users to create and post a daily log.
///
/// DailyLogueViewController effectively integrates UIKit components and functionality to provide a seamless and user-friendly experience for creating and posting daily logs.
///


// The ViewController where users can create and post a daily log
class DailyLogueViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
    
    
    // UI elements declaration
    let imageView = UIImageView() // ImageView to display selected image
    let descriptionTextView = UITextView() // TextView for the description of the post
    let postButton = UIButton(type: .system) // Button to post the log
    let cameraButton = UIButton(type: .system) // Button to select image
    let descriptionLabel = UILabel() // Label for the description field
    let recordDayLabel = UILabel() // Label to prompt users to record their day
    let THEME_COL: UIColor = UIColor(red: 84, green: 65, blue: 177) // Theme color
    let lightPurpleColor: UIColor = UIColor(red: 0.90, green: 0.75, blue: 0.98, alpha: 1.00) // Secondary color
    
    
    // Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor.black
            default:
                return UIColor.white
            }
        }
        
        // Set up the initial border color based on the current interface style
        updateBorderColor()
                
        let titleLabel = UILabel()
        titleLabel.text = "What's Up?"
        titleLabel.font = UIFont(name: "Lato-Regular", size: 25)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let subView = UIView()
        subView.backgroundColor = .systemBackground
        subView.layer.cornerRadius = 10
        subView.layer.shadowColor = THEME_COL.withAlphaComponent(0.3).cgColor
        subView.layer.shadowOpacity = 0.8
        subView.layer.shadowOffset = CGSize(width: 0, height: 2)
        subView.layer.shadowRadius = 4
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
        
        
        descriptionLabel.text = "Description"
        descriptionLabel.font = UIFont(name: "Lato-Regular", size: 18)
        descriptionLabel.textColor = .label
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        subView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 30),
            descriptionLabel.topAnchor.constraint(equalTo: subView.topAnchor, constant: 30) // Attach to top of subView.
        ])
        
        // Setup descriptionTextView.
        descriptionTextView.layer.borderWidth = 1.5
        descriptionTextView.layer.cornerRadius = 0.0
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.backgroundColor = .systemBackground
        descriptionTextView.textColor = .label
        if traitCollection.userInterfaceStyle == .dark {
            descriptionTextView.layer.borderColor = UIColor.label.cgColor
        } else {
            descriptionTextView.layer.borderColor = THEME_COL.withAlphaComponent(0.3).cgColor
        }

        subView.addSubview(descriptionTextView)
        
        descriptionTextView.delegate = self
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            descriptionTextView.centerXAnchor.constraint(equalTo: subView.centerXAnchor),
            descriptionTextView.widthAnchor.constraint(equalTo: subView.widthAnchor, multiplier: 0.65),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 130)
        ])
        
        
        // Setup recordDayLabel.
        recordDayLabel.text = "Record your day!"
        recordDayLabel.font = UIFont(name: "Lato-Regular", size: 18)
        recordDayLabel.textColor = .label
        recordDayLabel.translatesAutoresizingMaskIntoConstraints = false
        subView.addSubview(recordDayLabel)
        
        NSLayoutConstraint.activate([
            recordDayLabel.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 30),
            recordDayLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 30) // Attach to bottom of descriptionTextView.
        ])
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1.5
        imageView.backgroundColor = .systemBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if traitCollection.userInterfaceStyle == .dark {
            imageView.layer.borderColor = UIColor.label.cgColor
        } else {
            imageView.layer.borderColor = THEME_COL.withAlphaComponent(0.3).cgColor
        }

        subView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: recordDayLabel.bottomAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: subView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: subView.widthAnchor, multiplier: 0.65),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        
        cameraButton.setImage(UIImage(systemName: "camera"), for: .normal)
        cameraButton.tintColor = .label
        cameraButton.addTarget(self, action: #selector(selectImageTapped), for: .touchUpInside)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        subView.addSubview(cameraButton)
        
        NSLayoutConstraint.activate([
            cameraButton.centerXAnchor.constraint(equalTo: subView.centerXAnchor),
            cameraButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            cameraButton.widthAnchor.constraint(equalToConstant: 50),
            cameraButton.heightAnchor.constraint(equalTo: cameraButton.widthAnchor)
        ])
        
        postButton.setTitle("POST", for: .normal)
        postButton.backgroundColor = THEME_COL.withAlphaComponent(0.3)
        postButton.layer.cornerRadius = 5
        postButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        postButton.setTitleColor(THEME_COL, for: .normal)
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        
        subView.addSubview(postButton)
        
        NSLayoutConstraint.activate([
            postButton.centerXAnchor.constraint(equalTo: subView.centerXAnchor),
            postButton.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: -30),
            postButton.widthAnchor.constraint(equalTo: subView.widthAnchor, multiplier: 0.2),
            postButton.heightAnchor.constraint(equalToConstant: 25)
        ])

        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(pinchGesture)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Update the border color when the view appears
        updateBorderColor()
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        // Update the border color when the interface style changes
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateBorderColor()
        }
    }
    
    
    // Saves the selected image and description text to the file system
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
    
    
    // Handles post button tapped event
    @objc func postButtonTapped() {
        
        // Check if the text view is empty.
        if descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let alert = UIAlertController(title: "Missing Description", message: "Please enter a description.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Check if the image view has no image.
        if imageView.image == nil {
            let alert = UIAlertController(title: "Missing Image", message: "Please upload an image.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        saveImageTapped()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // Pinch gesture handler to scale the image
    @objc func handlePinch(gesture: UIPinchGestureRecognizer) {
        
        if gesture.state == .began || gesture.state == .changed {
            gesture.view?.transform = (gesture.view?.transform.scaledBy(x: gesture.scale, y: gesture.scale))!
            gesture.scale = 1
        }
        
    }
    
    
    // Gets the application's document directory
    func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
        
    }
    
    
    // Handler for the select image button tap
    @objc func selectImageTapped() {
        showPhotoOptions()
    }
    
    
    // Displays the photo source options
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
    
    
    // Opens the device camera
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
    
    
    // Opens the photo library
    func openGallery() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
        
    }
    
    
    // Image Picker Controller delegate method called when an image is selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        picker.dismiss(animated: true) {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let cropViewController = TOCropViewController(image: pickedImage)
                cropViewController.delegate = self
                cropViewController.customAspectRatio = CGSize(width: 1, height: 1)
                
                cropViewController.aspectRatioLockEnabled = true
                cropViewController.resetAspectRatioEnabled = true
                
                cropViewController.cropView.cropBoxResizeEnabled = true
                
                self.present(cropViewController, animated: true, completion: nil)
            }
        }
    }
    
    
    // TOCropViewController delegate method called when image cropping is done
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        imageView.image = image
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    
    // TOCropViewController delegate method called when cropping is cancelled
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    
    // Image Picker Controller delegate method called when image picking is cancelled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    
    // Formats a Date into a specific format
    func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
    
    

    func updateBorderColor() {
        
        if traitCollection.userInterfaceStyle == .dark {
            descriptionTextView.layer.borderColor = UIColor.label.cgColor
        } else {
            descriptionTextView.layer.borderColor = THEME_COL.withAlphaComponent(0.3).cgColor
        }
        
        if traitCollection.userInterfaceStyle == .dark {
            imageView.layer.borderColor = UIColor.label.cgColor
        } else {
            imageView.layer.borderColor = THEME_COL.withAlphaComponent(0.3).cgColor
        }
    }
    
}


// Extension to handle text view delegate methods
extension DailyLogueViewController: UITextViewDelegate {
    
    // Handles the event when text changes in the text view
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
