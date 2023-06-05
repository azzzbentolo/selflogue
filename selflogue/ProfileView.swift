import SwiftUI

struct ProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showingImagePicker = false
    @State private var showingActionSheet = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Button(action: {
                self.showingActionSheet = true
            }) {
                ZStack {
                    
                    Circle()
                        .fill(Color.secondary)
                        .frame(width: 150, height: 150)
                    
                    if let uiImage = self.viewModel.inputImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 150, height: 150)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .frame(width: 150, height: 150)
                    }
                }
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Select a picture"), buttons: [
                    .default(Text("Take a Picture"), action: {
                        self.sourceType = .camera
                        self.showingImagePicker = true
                    }),
                    .default(Text("Choose from library"), action: {
                        self.sourceType = .photoLibrary
                        self.showingImagePicker = true
                    }),
                    .cancel()
                ])
            }
            .padding(.top, 0)
            .padding(.bottom, 15)
            
            VStack(alignment: .leading) {
                Text("Name")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .padding(.horizontal, 30)
                
                TextField("Enter your name", text: .constant(""))
                    .font(.system(size: 20))
                    .padding(.horizontal, 30)
                    .padding(.top, -10)
            }.padding(.bottom, 15)
            
            VStack(alignment: .leading) {
                Text("Username")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .padding(.horizontal, 30)
                
                TextField("Enter your username", text: .constant(""))
                    .font(.system(size: 20))
                    .padding(.horizontal, 30)
                    .padding(.top, -10)
            }.padding(.bottom, 15)
            
            VStack(alignment: .leading) {
                Text("Bio")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .padding(.horizontal, 30)
                
                TextField("Enter your bio", text: .constant(""))
                    .font(.system(size: 20))
                    .padding(.horizontal, 30)
                    .padding(.top, -10)
            }.padding(.bottom, 15)
            
            VStack(alignment: .leading) {
                Text("Age")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .padding(.horizontal, 30)
                
                TextField("Enter your age", text: .constant(""))
                    .font(.system(size: 20))
                    .padding(.horizontal, 30)
                    .padding(.top, -10)
            }
            
            Button(action: {
                if let inputImage = self.viewModel.inputImage {
                    self.viewModel.saveImage(inputImage)
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Save")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $viewModel.inputImage, sourceType: self.sourceType)
        }
    }
    
    
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel())
    }
}
