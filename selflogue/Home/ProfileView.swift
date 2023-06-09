import SwiftUI


///  `ProfileView` is a SwiftUI `View` that represents the profile screen in the application.
///  It uses the `ProfileViewModel` to bind its data to the view.
///  It follows the Model-View-ViewModel (MVVM) architecture pattern, where `ProfileViewModel` is the ViewModel.
///  This design leverages OOP principles by encapsulating related data and behavior (like image loading and saving, and user profile details management) within the `ProfileViewModel` class.


struct ProfileView: View {
    
    
    // Environment variables and observed objects
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ProfileViewModel
    
    // State variables
    @State private var showingImagePicker = false
    @State private var showingActionSheet = false
    @State private var editMode = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    // Constants for max length of the text fields
    let maxNameLength = 20
    let maxUsernameLength = 10
    let maxBioLength = 50

    // The body of the ProfileView
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
                            .foregroundColor(Color(UIColor.systemGray3))
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
                
                TextField("Enter your name", text: $viewModel.name)
                    .font(.system(size: 20))
                    .padding(.horizontal, 30)
                    .padding(.top, -10)
                    .onChange(of: viewModel.name) { newValue in
                        if newValue.count > maxNameLength {
                            viewModel.name = String(newValue.prefix(maxNameLength))
                        }
                    }
            }.padding(.bottom, 15)
                .onReceive(viewModel.$name) { newValue in
                    UserDefaults.standard.set(newValue, forKey: "name")
                }
            
            VStack(alignment: .leading) {
                
                Text("Username")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .padding(.horizontal, 30)
                
                TextField("Enter your username", text: $viewModel.username)
                    .font(.system(size: 20))
                    .padding(.horizontal, 30)
                    .padding(.top, -10)
                    .onChange(of: viewModel.username) { newValue in
                        if newValue.count > maxUsernameLength {
                            viewModel.username = String(newValue.prefix(maxUsernameLength))
                        }
                    }
                
            }.padding(.bottom, 15)
                .onReceive(viewModel.$username) { newValue in
                    UserDefaults.standard.set(newValue, forKey: "username")
                }
            
            VStack(alignment: .leading) {
                
                Text("Bio")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .padding(.horizontal, 30)
                
                TextField("Enter your Bio", text: $viewModel.bio)
                    .font(.system(size: 20))
                    .padding(.horizontal, 30)
                    .padding(.top, -10)
                    .onChange(of: viewModel.bio) { newValue in
                        if newValue.count > maxBioLength {
                            viewModel.bio = String(newValue.prefix(maxBioLength))
                        }
                    }
            }.padding(.bottom, 15)
                .onReceive(viewModel.$bio) { newValue in
                    UserDefaults.standard.set(newValue, forKey: "bio")
                }
            
            VStack(alignment: .leading) {
                
                Text("Age")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .padding(.horizontal, 30)

                Picker(selection: $viewModel.age, label: Text("")) {
                    ForEach(8...100, id: \.self) {
                        Text("\($0)")
                            .font(.system(size: 25))
                            .foregroundColor(.black) 
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .labelsHidden()
                .padding(.horizontal, 30)
                .padding(.top, -10)
            }.padding(.bottom, 15)
            .onReceive(viewModel.$age) { newValue in
                UserDefaults.standard.set(newValue, forKey: "age")
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
