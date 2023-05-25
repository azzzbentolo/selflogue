import Foundation
import SwiftUI


class ImagesManager: ObservableObject {
    
    static let shared = ImagesManager()

    @Published var imageFiles: [String: (UIImage, String)] = [:]  

    private init() {
        loadImageFiles()
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func loadImageFiles() {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentsDirectory().path)
            var imageFilesDict: [String: (UIImage, String)] = [:] // Dictionary to store image files
            for file in files {
                if file.hasSuffix(".png"), let image = UIImage(contentsOfFile: getDocumentsDirectory().appendingPathComponent(file).path) {
                    let descriptionFileName = file.replacingOccurrences(of: ".png", with: ".txt") // changed this
                    let descriptionFilePath = getDocumentsDirectory().appendingPathComponent(descriptionFileName).path
                    let description = (try? String(contentsOfFile: descriptionFilePath, encoding: .utf8)) ?? ""
                    imageFilesDict[file] = (image, description)
                }
            }
            // Sort the image file names (keys) in descending order
            let sortedKeys = imageFilesDict.keys.sorted(by: >)
            
            // Create a new dictionary with the sorted keys
            var sortedImageFilesDict: [String: (UIImage, String)] = [:]
            for key in sortedKeys {
                if let value = imageFilesDict[key] {
                    sortedImageFilesDict[key] = value
                }
            }
            
            // Update the imageFiles property
            imageFiles = sortedImageFilesDict
        } catch {
            print("Failed to read directory: \(error)")
        }
    }


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

}
