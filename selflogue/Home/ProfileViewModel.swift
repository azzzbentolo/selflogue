import SwiftUI

class ProfileViewModel: ObservableObject {
    
    @Published var inputImage: UIImage?
    @Published var name: String = UserDefaults.standard.string(forKey: "name") ?? ""
    @Published var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @Published var bio: String = UserDefaults.standard.string(forKey: "bio") ?? ""
    @Published var age: Int = 8
    
    let imageStorageFileName = "profilePicture.png"

    init() {
        if let savedImage = loadImage() {
            self.inputImage = savedImage
        }
    }
    
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
