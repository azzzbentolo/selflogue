import SwiftUI


struct ImagesListView: View {
    
    
    @ObservedObject var imagesManager = ImagesManager.shared
    @State private var selectedImageIndex = 0
    var selectedDate: Date
    
    
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

    
    func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM, yyyy"
        return formatter.string(from: date)
    }
}
