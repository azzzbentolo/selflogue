
/// `ProfileViewModel` is a view model class responsible for managing the profile information of a user in the application.
///
/// It follows the MVVM (Model-View-ViewModel) architecture, where the view model handles the data and behavior related to the user's profile, and the view (SwiftUI views) represents the user interface.
///
/// The class utilizes the ObservableObject protocol to enable two-way data binding with SwiftUI views. It publishes properties that trigger UI updates when they change.
///
/// We can say that this class follows OOP because it encapsulates the logic for managing the user's profile information, including profile picture, name, username, bio, and age. It provides methods for saving and loading profile data.
///
/// `ProfileViewModel` effectively handles the data and behavior related to the user's profile, allowing for easy integration with SwiftUI views and enabling seamless two-way data binding.


import SwiftUI


class ProfileViewModel: ObservableObject {
    
    // Published properties for two-way binding with SwiftUI views. These properties will trigger UI updates when they change.
    @Published var inputImage: UIImage?
    @Published var name: String = UserDefaults.standard.string(forKey: "name") ?? ""
    @Published var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @Published var bio: String = UserDefaults.standard.string(forKey: "bio") ?? ""
    @Published var age: Int = 8
    
    
    // Filename for storing the profile picture.
    let imageStorageFileName = "profilePicture.png"

    
    // Initializer. Loads any saved image from file.
    init() {
        if let savedImage = loadImage() {
            self.inputImage = savedImage
        }
    }
    
    
    // Helper method to get the URL of the app's documents directory.
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let profileDataPath = paths[0].appendingPathComponent("profileData", isDirectory: true)
        
        do {
            try FileManager.default.createDirectory(at: profileDataPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Couldn't create directory")
        }
        
        return profileDataPath
    }
    
    
    // Saves an image to the documents directory.
    func saveImage(_ image: UIImage) {
        if let pngData = image.pngData() {
            let filePath = getDocumentsDirectory().appendingPathComponent(imageStorageFileName)
            do {
                try pngData.write(to: filePath)
            } catch {
                print("Couldn't write image")
            }
        }
    }
    
    
    // Loads an image from the documents directory.
    func loadImage() -> UIImage? {
        let filePath = getDocumentsDirectory().appendingPathComponent(imageStorageFileName)
        do {
            let imageData = try Data(contentsOf: filePath)
            return UIImage(data: imageData)
        } catch {
            print("Couldn't load image from \(filePath)")
        }
        return nil
    }
}
