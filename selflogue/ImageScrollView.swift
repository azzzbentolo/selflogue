import SwiftUI

struct ImagesScrollView: View {
    @ObservedObject var imagesManager = ImagesManager.shared
    @State private var showingDeleteAlert = false
    @State private var selectedImage: String?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(Array(imagesManager.imageFiles).sorted(by: { $0.value.2 > $1.value.2 }), id: \.key) { imageName, imageTuple in
                    ZStack(alignment: .topTrailing) {
                        VStack(alignment: .leading) {
                            Image(uiImage: imageTuple.0)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 350, height: 350)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(EdgeInsets(top: 50, leading: 30, bottom: 0, trailing: 30))
                            
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
                        }
                        .padding(.bottom)
                        
                        Menu {
                            Button(action: {
                                selectedImage = imageName
                                showingDeleteAlert = true
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                            Button(action: {
                                // Action for share button
                            }) {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.title)
                                .foregroundColor(.black)
                                .padding(.trailing, 30)
                                .padding(.top, 40)
                        }
                        .padding(.top, -10)
                    }
                    .alert(isPresented: $showingDeleteAlert) {
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
