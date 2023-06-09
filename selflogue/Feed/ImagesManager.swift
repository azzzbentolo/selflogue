import Foundation
import SwiftUI


/// `ImagesManager` is a singleton class that manages images and their associated data within the application.
/// This class serves as a central repository for images, following the Singleton design pattern in OOP to provide a global access point to this resource.
///
/// `ImagesManager` acts as the ViewModel in the MVVM architecture, providing an interface between the model (image data) and the view.
/// It loads, deletes, and manages image files and their associated data (image descriptions and timestamps), encapsulating these operations and hiding the internal implementation details.
///
/// This class uses the `FileManager` to read from and write to the device's filesystem, providing object-oriented encapsulation for these operations.
///
/// The use of SwiftUI's `@Published` property wrapper for `imageFilesDict` and `imageFiles` allows `ImagesManager` to provide observable data that can be used to update the UI when changes occur, following the principles of the Observer design pattern in OOP.
///
/// By providing methods to load and delete images, `ImagesManager` encapsulates the image management functionality and hides the complexity of file management operations from the rest of the application.


// ImagesManager class which is an ObservableObject, allowing its published properties to be observed by SwiftUI views
class ImagesManager: ObservableObject {
    
    
    // Singleton instance of ImagesManager to allow it to be accessed globally
    static let shared = ImagesManager()
    
    
    // Published properties that will trigger SwiftUI updates on change
    @Published var imageFilesDict: [String: (UIImage, String, Date)] = [:]
    @Published var imageFiles: [String: (UIImage, String, Date)] = [:]

    
    // Private initializer for the Singleton pattern
    private init() {
        loadImageFiles()
    }

    
    // Function to get the directory to store image files
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    // Function to load image files from the directory
    func loadImageFiles() {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentsDirectory().path)
            var imageFilesArray: [(String, UIImage, String, Date)] = [] // Array of tuples
                    
            for file in files {
                if file.hasSuffix(".png"), let image = UIImage(contentsOfFile: getDocumentsDirectory().appendingPathComponent(file).path) {
                    let descriptionFileName = file.replacingOccurrences(of: ".png", with: ".txt")
                    let descriptionFilePath = getDocumentsDirectory().appendingPathComponent(descriptionFileName).path
                    let descriptionAndTimestamp = (try? String(contentsOfFile: descriptionFilePath, encoding: .utf8))?.components(separatedBy: "\n") ?? ["", ""]
                    let timestamp = self.formatBack(dateString: descriptionAndTimestamp[1])
                    imageFilesArray.append((file, image, descriptionAndTimestamp[0], timestamp))
                }
            }
            
            imageFilesArray.sort { $0.3 > $1.3 }
            print("Sorted: \(imageFilesArray)")
            
            for fileTuple in imageFilesArray {
                imageFiles[fileTuple.0] = (fileTuple.1, fileTuple.2, fileTuple.3)
            }
            
        } catch {
            print("Failed to read directory: \(error)")
        }
    }

    // Function to delete an image file with a given name
    func deleteImage(named imageName: String) {
        
        let fileManager = FileManager.default
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName).path
        let descriptionFileName = imageName.replacingOccurrences(of: ".png", with: ".txt") // changed this
        let descriptionFilePath = getDocumentsDirectory().appendingPathComponent(descriptionFileName).path
        
        do {
            try fileManager.removeItem(atPath: imagePath)
            try fileManager.removeItem(atPath: descriptionFilePath)
            imageFiles.removeValue(forKey: imageName)
        } catch {
            print("Could not delete file: \(error)")
        }
        
    }
    
    
    func formatBack(dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.current
        
        if let date = formatter.date(from: dateString) {
            return date
        } else {
            print("Error: Can't convert \(dateString) to Date")
            return Date()
        }
    }
}
