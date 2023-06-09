import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            
            VStack(alignment: .leading) {
                Text("ToCropViewController")
                    .padding(.bottom, 10)
                    .font(.system(size: 16).bold())
                Text("A view controller for iOS that allows users to crop portions of UIImage objects")
                    .padding(.bottom, 2)
                    .font(.system(size: 13))
                Text("Copyright © 2015-2022 Tim Oliver")
                    .padding(.bottom, 2)
                    .font(.system(size: 13))
                Link("Source Code", destination: URL(string: "https://github.com/TimOliver/TOCropViewController")!)
                    .font(.system(size: 13))
            }
            .padding(.vertical)
            
            VStack(alignment: .leading) {
                Text("FSCalendar")
                    .padding(.bottom, 10)
                    .font(.system(size: 16).bold())
                Text("A fully customizable iOS calendar library, compatible with Objective-C and Swift.")
                    .padding(.bottom, 2)
                    .font(.system(size: 13))
                Text("Copyright © 2013-2016 FSCalendar")
                    .padding(.bottom, 2)
                    .font(.system(size: 13))
                Link("Source Code", destination: URL(string: "https://github.com/WenchaoD/FSCalendar")!)
                    .font(.system(size: 13))
            }
            .padding(.vertical)
            
            VStack(alignment: .leading) {
                Text("Quotable API")
                    .padding(.bottom, 10)
                    .font(.system(size: 16).bold())
                Text("Random Quotes API")
                    .padding(.bottom, 2)
                    .font(.system(size: 13))
                Text("Copyright © 2019 Luke Peavey")
                    .padding(.bottom, 2)
                    .font(.system(size: 13))
                Link("API Documentation", destination: URL(string: "https://github.com/lukePeavey/quotable")!)
                    .font(.system(size: 13))
            }
            .padding(.vertical)
        }
        .navigationBarTitle("Acknowledgements", displayMode: .inline)
    }
}
