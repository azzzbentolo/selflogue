import SwiftUI

struct ImagesScrollView: View {
    @ObservedObject var imagesManager = ImagesManager.shared
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(imagesManager.imageFiles.reversed(), id: \.self) { imageName in
                    Image(uiImage: UIImage(contentsOfFile: imagesManager.getDocumentsDirectory().appendingPathComponent(imageName).path) ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .onTapGesture {
                            imagesManager.deleteImage(named: imageName)
                        }
                }
            }
        }
    }
}
