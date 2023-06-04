import SwiftUI

struct ImagesScrollView: View {
    
    
    @ObservedObject var imagesManager = ImagesManager.shared
    @State private var showingAlert = false
    @State private var selectedImage: String?

    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(Array(imagesManager.imageFiles.keys), id: \.self) { imageName in
                    VStack(alignment: .leading) {
            
                        Image(uiImage: imagesManager.imageFiles[imageName]?.0 ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350, height: 350)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(EdgeInsets(top: 50, leading: 30, bottom: 0, trailing: 30))
                        
                        if let imageTuple = imagesManager.imageFiles[imageName] {
                            Text(imageTuple.1)
                                .font(.system(size: 15))
                                .padding(.leading, 30)
                                .padding(.trailing, 30)
                                .padding(.top, 0)
                                .padding(.bottom, 0)

                            Text(format(date: imageTuple.2))
                                .font(.system(size: 15))
                                .padding(.leading, 30)
                                .padding(.trailing, 30)
                                .padding(.top, 0)
                                .padding(.bottom, 10)
                        } else {
                            Text("No Description")
                                .font(.system(size: 15))
                                .padding(.leading, 30)
                                .padding(.trailing, 30)
                                .padding(.top, 0)
                                .padding(.bottom, 10)
                        }
                        
                        HStack {
                            Button(action: {
                                selectedImage = imageName
                                showingAlert = true
                            }) {
                                Image(systemName: "trash")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .frame(width: 20, height: 20)
                            }
                            .padding(.leading, 30)
                            
                            Spacer()
                            
                            Button(action: {
                                // Action for share button
                            }) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .frame(width: 20, height: 20)
                            }
                            .padding(.trailing, 30)
                        }
                    }
                    .padding(.bottom)
                    .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("Delete"),
                            message: Text("Are you sure you want to delete this image?"),
                            primaryButton: .destructive(Text("Delete")) {
                                if let imageName = selectedImage {
                                    imagesManager.deleteImage(named: imageName)
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
        }
    }
}

