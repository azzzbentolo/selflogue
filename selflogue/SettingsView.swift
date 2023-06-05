import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account")) {
                    NavigationLink(destination: ProfileView()) {
                        Text("Edit Profile")
                    }
                    Text("Privacy")
                }

                Section(header: Text("General")) {
                    Text("Language")
                    Text("Notifications")
                }

                Section(header: Text("Support")) {
                    Text("Help")
                    Text("About")
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
