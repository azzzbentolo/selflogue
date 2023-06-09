import SwiftUI


/// `SettingsView` is a SwiftUI view responsible for displaying the settings screen. It utilizes the `ProfileViewModel` class to manage the user's profile information and updates.
///
/// The view utilizes the StateObject property wrapper to manage the lifecycle of the `profileViewModel` instance.
///
/// The class follows the OOP as it encapsulates the logic for displaying the settings screen and navigating to the profile editing view. It utilizes the ProfileViewModel to handle the user's profile data.
///


// This view presents the settings of the application, including a link to the ProfileView
struct SettingsView: View {
    
    // StateObject is used here because the view owns the model
    @StateObject var profileViewModel = ProfileViewModel()
    
    var body: some View {
        
        NavigationView {
            
            Form {
                Section(header: Text("Account")) {
                    NavigationLink(destination: ProfileView(viewModel: profileViewModel)) {
                        Text("Edit Profile")
                    }
                }
                
                Section(header: Text("About")) {
                    NavigationLink(destination: AboutView()) {
                        Text("Acknowledgements")
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
