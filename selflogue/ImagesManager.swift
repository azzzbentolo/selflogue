import Foundation
import SwiftUI


class ImagesManager: ObservableObject {
    static let shared = ImagesManager()

    @Published var imageFiles: [String] = []

    private init() {
        loadImageFiles()
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    public func loadImageFiles() {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentsDirectory().path)
            imageFiles = files
        } catch {
            print("Failed to read directory: \(error)")
        }
    }

    func deleteImage(named imageName: String) {
        let fileManager = FileManager.default
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName).path
        do {
            try fileManager.removeItem(atPath: imagePath)
            if let index = imageFiles.firstIndex(of: imageName) {
                imageFiles.remove(at: index)
            }
        } catch {
            print("Could not delete file: \(error)")
        }
    }
}
