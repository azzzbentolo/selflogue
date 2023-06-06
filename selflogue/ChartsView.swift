//import SwiftUI
//import Charts
//
//struct FocusTimeData: Identifiable {
//    let id = UUID()
//    let dayOfWeek: String
//    let focusTime: Double
//}
//
//struct BarView: View {
//    let focusData: FocusTimeData
//    let maximumFocusTime: Double
//
//    var body: some View {
//        VStack {
//            ZStack(alignment: .bottom) {
//                Capsule().frame(width: 30, height: 200)
//                    .foregroundColor(.gray.opacity(0.1))
//                Capsule().frame(width: 30, height: CGFloat(focusData.focusTime / maximumFocusTime) * 200)
//                    .foregroundColor(.blue)
//            }
//            Text(focusData.dayOfWeek)
//                .font(.footnote)
//        }
//    }
//}
//
//struct FocusTimeChartView: View {
//    @State private var focusTimeData = [FocusTimeData]()
//
//    var body: some View {
//        HStack {
//            ForEach(focusTimeData) { data in
//                BarView(focusData: data, maximumFocusTime: self.maximumFocusTime())
//            }
//        }
//        .onAppear {
//            self.fetchFocusTimeData()
//        }
//    }
//
//    private func fetchFocusTimeData() {
//        // Get an instance of your NSManagedObjectContext here.
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        let context = appDelegate.persistentContainer.viewContext
//
//        // Instantiate FocusTimeManager with the context.
//        let focusTimeManager = FocusTimeManager(context: context)
//
//        // Assume that the first day of the week is Sunday and the last day is Saturday.
//        let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
//
//        // Use a Calendar instance to get the start of the current week.
//        var calendar = Calendar.current
//        calendar.firstWeekday = 1  // Sunday
//        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else {
//            return
//        }
//
//        // Fetch the focus time for each day of the current week.
//        focusTimeData = daysOfWeek.indices.compactMap { index in
//            let date = calendar.date(byAdding: .day, value: index, to: startOfWeek)!
//            let focusTime = focusTimeManager.getFocusTime(for: date)
//            print(focusTime)
//            return FocusTimeData(dayOfWeek: daysOfWeek[index], focusTime: Double(focusTime))
//            
//        }
//    }
//
//
//    private func maximumFocusTime() -> Double {
//        return focusTimeData.map { $0.focusTime }.max() ?? 1
//    }
//}


//Chart {
//  // 2
//  ForEach(0..<7, id: \.self) { month in
//    // 3
//    let precipitationValue = sumPrecipitation(month)
//    let monthName = DateUtils.monthAbbreviationFromInt(month)
//    // 4
//    BarMark(
//      // 5
//      x: .value("Month", monthName),
//      // 6
//      y: .value("Precipitation", precipitationValue)
//    )
//  }
//}


import SwiftUI
import Charts

struct FocusTimeData: Identifiable {
    let id = UUID()
    let date: Date
    let focusTime: Double
}

private func fetchFocusTimeData() -> [FocusTimeData] {
    var focusTimeData = [FocusTimeData]()
    
    // Get an instance of your NSManagedObjectContext here.
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return focusTimeData
    }
    let context = appDelegate.persistentContainer.viewContext

    // Instantiate FocusTimeManager with the context.
    let focusTimeManager = FocusTimeManager(context: context)

    // Use a Calendar instance to get the start of the current week.
    var calendar = Calendar.current
    calendar.firstWeekday = 2  // Monday
    guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else {
        return focusTimeData
    }

    // Fetch the focus time for each day of the current week.
    for index in 0..<7 {
        let date = calendar.date(byAdding: .day, value: index, to: startOfWeek)!
        let focusTime = focusTimeManager.getFocusTime(for: date)
        print(focusTime)
        focusTimeData.append(FocusTimeData(date: date, focusTime: Double(focusTime)))
    }
    return focusTimeData
}

struct BarChart: View {
    @State private var focusTimeData = [FocusTimeData]()

    var body: some View {
        Chart(focusTimeData) {
              BarMark(
                 x: .value("Date", $0.date), // Adjust the date format as needed
                 y: .value("Focus Time", $0.focusTime)
              )
        }
        .onAppear {
            self.focusTimeData = fetchFocusTimeData()
        }
    }
}
