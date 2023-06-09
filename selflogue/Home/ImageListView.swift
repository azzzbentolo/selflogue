
/// `ImagesListView` is a SwiftUI view responsible for displaying a list of images associated with a selected date. It integrates with the ImagesManager class to fetch and filter the images for the selected date.
///
/// The view utilizes the ObservedObject property wrapper to observe changes in the `imagesManager` instance.
/// It also uses the State property wrapper to manage the currently selected image index.
///
/// The class encapsulates the logic for filtering and displaying images for a specific date. It utilizes private methods to handle the image filtering and formatting of the selected date. Hence, we can say that it follows OOP principle.
///


import SwiftUI


// This view is responsible for displaying images associated with a specific date.
// It displays these images in a paged view, along with associated descriptions.
struct ImagesListView: View {
    
    
    // ImagesManager shared instance is observed for changes in imageFiles
    @ObservedObject var imagesManager = ImagesManager.shared
    
    // State for managing the currently selected image index
    @State private var selectedImageIndex = 0
    
    // The date for which images should be displayed
    var selectedDate: Date
    
    
    // Filter images to display only those associated with the selected date
    private var imagesForDate: [(String, (UIImage, String, Date))] {
        return imagesManager.imageFiles.filter { $0.value.2.dateOnly() == selectedDate }
    }

    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Logue")
                .font(.custom("Lato-Bold", size: 34))
                .fontWeight(.bold)
                .padding(.top, 40)
                .padding(.leading, 10)
                .padding(.bottom, 50)
            
            Text(format(date: selectedDate))
                .font(.custom("Lato-Bold", size: 25))
                .fontWeight(.bold)
                .padding(.leading, 10)
                .padding(.bottom, -130) 

            if !imagesForDate.isEmpty {
                TabView(selection: $selectedImageIndex) {
                    ForEach(0..<imagesForDate.count, id: \.self) { index in
                        VStack {
                            
                            Image(uiImage: imagesForDate[index].1.0)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(15)
                                .padding(.top, -130) 

                            Text(imagesForDate[index].1.1)
                                .font(.custom("Lato-Regular", size: 19))
                                .padding(.top, 10)
                                .font(.system(size: 18))
                        }
                        .padding(.bottom, 30)
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
        }
        .padding(.horizontal, 30)
    }

    
    // Helper function to format date in "dd MMMM, yyyy" format
    func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM, yyyy"
        return formatter.string(from: date)
    }
}
