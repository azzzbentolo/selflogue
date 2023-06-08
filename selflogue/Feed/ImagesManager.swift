import Foundation
import SwiftUI


class ImagesManager: ObservableObject {
    
    
    static let shared = ImagesManager()
    @Published var imageFilesDict: [String: (UIImage, String, Date)] = [:]
    @Published var imageFiles: [String: (UIImage, String, Date)] = [:]


    
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
