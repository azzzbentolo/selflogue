import SwiftUI

class ProfileViewModel: ObservableObject {
    
    @Published var inputImage: UIImage?
    let imageStorageFileName = "profilePicture.png"

    init() {
        if let savedImage = loadImage() {
            self.inputImage = savedImage
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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
