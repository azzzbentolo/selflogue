
/// `ImagePicker` is a struct that conforms to UIViewControllerRepresentable, making it a bridge between SwiftUI and UIKit.
///
/// In the context of the MVVM (Model-View-ViewModel) architecture, `ImagePicker` serves as a View, presenting a `UIImagePickerController` (a UIKit component) in a SwiftUI view.
///
/// `ImagePicker` uses a nested Coordinator class to manage the delegation for the` UIImagePickerController`. This Coordinator takes on a role similar to a ViewModel, as it handles the communication between the SwiftUI View (ImagePicker) and the UIKit's `UIImagePickerController`.
///
/// `ImagePicker` creates and updates UIImagePickerController instances.
/// It provides a Coordinator to manage interactions with UIImagePickerController.
/// Also, it handles the user's image selection and cancel actions, and reflecting those changes in a @Binding variable selectedImage.
///
/// `ImagePicker` plays an essential role in integrating UIKit's functionality within a SwiftUI context. It hides the internal details of bridging SwiftUI and UIKit, thereby adhering to the encapsulation aspect of Object-Oriented Programming (OOP).


import SwiftUI


// ImagePicker is a struct conforming to UIViewControllerRepresentable
// Allows UIKit view controller to be represented in SwiftUI
struct ImagePicker: UIViewControllerRepresentable {
    
    
    // Environment object used to dismiss the ImagePicker view
    @Environment(\.presentationMode) private var presentationMode
    
    
    // Binding to a UIImage variable, allowing for two-way data communication
    @Binding var selectedImage: UIImage?
    
    
    // Source type for the ImagePickerController (camera or photo library)
    let sourceType: UIImagePickerController.SourceType
    
    
    // Required function to make the UIViewController
    // Returns an instance of UIImagePickerController with the required sourceType
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = self.sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    
    // Required function to update the UIViewController
    // No functionality required in this case as the image picker does not need to update any child views
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    
    // Function to create a coordinator object to manage image picking process
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    // Coordinator class acting as a bridge between the image picker and SwiftUI
    // Conforms to UIImagePickerControllerDelegate and UINavigationControllerDelegate to manage image picking and navigation
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        // Reference to parent ImagePicker view
        var parent: ImagePicker

        // Initialize with reference to parent view
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        // Function called when an image is picked
        // Sets selectedImage in parent view and dismisses the ImagePicker
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        // Function called when image picking is canceled
        // Dismisses the ImagePicker view
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
}
