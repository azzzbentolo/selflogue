import SwiftUI

struct ImagesScrollView: View {
    
    @ObservedObject var imagesManager = ImagesManager.shared

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(Array(imagesManager.imageFiles.keys.reversed()), id: \.self) { imageName in
                    VStack {
                        if let imageTuple = imagesManager.imageFiles[imageName] {
                            Text(imageTuple.1)
                                .font(.system(size: 16))
                                .padding(.bottom)
                        } else {
                            Text("No Description")
                                .font(.system(size: 16))
                                .padding(.bottom)
                        }

                        Image(uiImage: imagesManager.imageFiles[imageName]?.0 ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                    .onTapGesture {
                        imagesManager.deleteImage(named: imageName)
                    }
                }
            }
        }
    }
}
