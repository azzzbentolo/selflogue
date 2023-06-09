
/// `AboutView` is a SwiftUI `View` which presents a list of third-party libraries used in the application.
/// It follows the Model-View-ViewModel (MVVM) architecture, where it acts as the View component in the architecture.
/// It is responsible for presenting data to the user and capturing user interactions.
/// This View does not interact directly with the Model. Instead, it communicates with the ViewModel which then handles any necessary Model interactions.
/// `AboutView` employs principles of Object-Oriented Programming (OOP), including encapsulation by defining properties and methods within the struct,
/// and abstraction by simplifying complex implementations into easy-to-understand interfaces.


import SwiftUI


struct AboutView: View {
    var body: some View {
        
        // A List view is used to present a number of rows in a single column, representing the acknowledgements in this case.
        List {
            
            // Each VStack contains Text and Link views representing details about a library, grouped together vertically.
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
