import SwiftUI

struct ImagesScrollView: View {

  @ObservedObject var imagesManager = ImagesManager.shared
  @State private var showingDeleteAlert = false
  @State private var selectedImage: String?

  var body: some View {

    ScrollView(showsIndicators: false) {
      VStack {
        ForEach(getUniqueDates(), id: \.self) { date in
          VStack {
            HStack {
              Text(format(date: date))
                .font(.custom("Lato-Bold", size: 25))  // Increase font size
              Spacer()
            }
            .padding(.leading, 20)
            .padding(.top, 40)
            .padding(.bottom, 30)

            ForEach(getImagesForDate(date).sorted(by: { $0.1.2 > $1.1.2 }), id: \.0) {
              imageName, imageTuple in
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

  func getUniqueDates() -> [Date] {
    return Array(Set(imagesManager.imageFiles.values.map { $0.2.dateOnly() })).sorted(by: >)
  }

  func getImagesForDate(_ date: Date) -> [(String, (UIImage, String, Date))] {
    return imagesManager.imageFiles.filter { $0.value.2.dateOnly() == date }
  }

  func format(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    return formatter.string(from: date)
  }

  func formatTime(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
  }
}

extension Date {

  func dateOnly() -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: self)
    return calendar.date(from: components) ?? self
  }

}
