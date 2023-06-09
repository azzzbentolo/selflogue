import SwiftUI


struct SettingsView: View {
    
    @StateObject var profileViewModel = ProfileViewModel()
    
    var body: some View {
        
        NavigationView {
            
            Form {
                Section(header: Text("Account")) {
                    NavigationLink(destination: ProfileView(viewModel: profileViewModel)) {
                        Text("Edit Profile")
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
