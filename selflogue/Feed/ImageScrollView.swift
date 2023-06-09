
/// `ImagesScrollView` is a SwiftUI View that presents a scrollable list of images along with their associated data (time of capture and description).
/// This struct acts as the View in the MVVM architecture, displaying images and their data from the ImagesManager, and also capturing user inputs (deleting an image).
///
/// It uses the `@ObservedObject` property wrapper to observe changes in the `ImagesManager` singleton instance. This follows the Observer design pattern in OOP and enables the UI to update when changes to the observed object occur.
///
/// In addition, `ImagesScrollView` groups images by the date of their capture, and sorts them within each date group. It encapsulates the logic of formatting and displaying date and time information, adhering to the principles of OOP by separating this functionality into distinct methods.
///
/// The use of SwiftUI's `ForEach` to iterate over and display images adheres to the MVVM architecture by decoupling the data (images and their details) from the way they are presented in the UI.
///
/// Also, `ImagesScrollView` encapsulates the user interaction of deleting an image within an alert dialog, further demonstrating the encapsulation principle of OOP.


import SwiftUI


// ImagesScrollView is a View struct that displays images
struct ImagesScrollView: View {
    
    
    // imagesManager object observed for changes
    @ObservedObject var imagesManager = ImagesManager.shared
    
    
    // State variables for managing UI
    @State private var showingDeleteAlert = false
    @State private var selectedImage: String?
    
    
    // Body of the view that renders the UI
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(getUniqueDates(), id: \.self) { date in
                    VStack {
                        HStack {
                            Text(format(date: date))
                                .font(.custom("Lato-Bold", size: 25)) // Increase font size
                            Spacer()
                        }
                        .padding(.leading, 20)
                        .padding(.top, 40)
                        .padding(.bottom, 30)
                        
                        ForEach(getImagesForDate(date).sorted(by: { $0.1.2 > $1.1.2 }), id: \.0) { imageName, imageTuple in
                            ZStack {
                                VStack {
                                    
                                    Text(formatTime(date: imageTuple.2))
                                        .font(.custom("Lato-Regular", size: 18))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 20)
                                        .padding(.bottom, 0)
                                    
                                    Image(uiImage: imageTuple.0)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 315, height: 315)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.horizontal, 40)
                                    
                                    Text(imageTuple.1)
                                        .font(.custom("Lato-Regular", size: 17))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 50)
                                        .padding(.top, 0)
                                        .padding(.bottom, 0)
                                }
                                .padding(.bottom)
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
                                
                                Menu {
                                    Button(action: {
                                        selectedImage = imageName
                                        showingDeleteAlert = true
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .font(.system(size: 17))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                .padding(.trailing, 60)
                                .padding(.top, 45)
                            }
                            
                            .padding(.bottom)
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
    }
    
    
    // Function to get unique dates for images
    func getUniqueDates() -> [Date] {
        return Array(Set(imagesManager.imageFiles.values.map { $0.2.dateOnly() })).sorted(by: >)
    }
    
    
    // Function to get images for a specific date
    func getImagesForDate(_ date: Date) -> [(String, (UIImage, String, Date))] {
        return imagesManager.imageFiles.filter { $0.value.2.dateOnly() == date }
    }
    
    
    // Function to format a Date object into a string
    func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
    
    // Function to format a Date object into a time string
    func formatTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}


// Date extension to get date only (without time)
extension Date {
    
    func dateOnly() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components) ?? self
    }
    
}
