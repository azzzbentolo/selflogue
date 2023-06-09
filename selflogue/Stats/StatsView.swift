import SwiftUI
import Charts


/// `StatsView` is the View component in the MVVM architecture. It's responsibility is to present the data to the user in a meaningful and interactive manner. It primarily focuses on UI and user interactions, devoid of any business logic.
///
/// `StatsView` interacts with `StatsViewModel` to get the data it needs to display. This includes data for weekly and monthly focus times. It observes the data changes from `StatsViewModel` and updates the UI accordingly.
///
/// The UI contains charts (either line or bar, toggled by user interaction) to represent the user's focus time over a specific period
/// (a week or a month), along with the total focus time for the selected period.
///
/// Overall, `StatsView` plays a critical role in representing the data provided by the `StatsViewModel` to the user in a visually pleasing and intuitive manner.
///
/// `StatsView` adheres to principles of good OOP design, maintaining single responsibility and a clean separation of concerns.


// `FocusTimeData` is a data structure that encapsulates focus time information.
// It conforms to the `Identifiable` protocol to be easily used in SwiftUI Lists and ForEach constructs.
struct FocusTimeData: Identifiable {
    let id = UUID()
    var date: Date
    let focusTime: Double
    var animate: Bool = false
}


// StatsView is a view that displays statistical data to the user.
struct StatsView: View {
    
    //MARK: State Chart Data For Animation Changes
    
    // State variables to hold and respond to changes in focus time data for the week and month.
    @State var focusTimeDataWeek = [FocusTimeData]()
    @State var focusTimeDataMonth = [FocusTimeData]()
    
    // State variables to hold the currently active items for the week and month view.
    @State var currentActiveItemWeek: FocusTimeData?
    @State var currentActiveItemMonth: FocusTimeData?
    
    // State variable to hold the current tab view ("Week" or "Month").
    @State var currentTab: String = "Week"
    
    // State variable to hold the currently active item.
    @State var currentActiveItem: FocusTimeData? = nil
    
    // State variable to hold the width of the plot.
    @State var plotWidth: CGFloat = 0
    
    // State variable to determine if the chart is line chart or not.
    @State var isLineChart: Bool = false
    
    // ViewModel that provides data and handles logic.
    @ObservedObject var viewModel = StatsViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    
    // The body of the StatsView.
    var body: some View {
        
        VStack{
            VStack(alignment: .leading, spacing: 12) {
                
                HStack {
                    Text("Time Focused")
                        .fontWeight(.semibold)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    Spacer()
                    
                    Picker("", selection: $currentTab) {
                        Text("Week").tag("Week")
                        Text("Month").tag("Month")
                    }
                    .pickerStyle(.segmented)
                    .padding(.leading, 50)
                }
                .padding(.horizontal, 0)
                
                if currentTab == "Week" {
                    let totalValue = focusTimeDataWeek.reduce(0.0) { partialResult, item in
                        item.focusTime + partialResult
                    }
                    
                    Text(String(Int32(totalValue)) + " s")
                        .font(.largeTitle.bold())
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    
                    AnimatedChart(time: "Week", focusTimeData: $focusTimeDataWeek, currentActiveItem: $currentActiveItemWeek)
                    
                } else if currentTab == "Month" {
                    
                    let totalValue = focusTimeDataMonth.reduce(0.0) { partialResult, item in
                        item.focusTime + partialResult
                    }
                    
                    Text(String(Int32(totalValue)) + " s")
                        .font(.largeTitle.bold())
                    
                    AnimatedChart(time: "Month", focusTimeData: $focusTimeDataMonth, currentActiveItem: $currentActiveItemMonth)
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                // This will change the background color based on the color scheme
                    .fill(colorScheme == .dark ? Color.black : Color.white)
            }
            Toggle("Line Chart", isOn: $isLineChart)
                .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
    }
    
    
    // A helper function that creates an animated chart based on the given time (week or month) and focus time data.
    // A helper function that creates an animated chart based on the given time (week or month) and focus time data.
    @ViewBuilder
    func AnimatedChart(time: String, focusTimeData: Binding<[FocusTimeData]>, currentActiveItem: Binding<FocusTimeData?>) -> some View {
        
        let max = focusTimeData.wrappedValue.max {item1, item2 in
            return item2.focusTime > item1.focusTime
        }?.focusTime ?? 0
        let timing: String = time
        
        Chart {
            
            ForEach(focusTimeData.wrappedValue) { item in
                
                if isLineChart {
                    LineMark(
                        x: .value("Date", item.date, unit: timing == "Week" ? .day : .month),
                        y: .value("Focus Time", item.animate ? item.focusTime : 0)
                    )
                    .foregroundStyle(Color("Color3").gradient)
                    .interpolationMethod(.catmullRom)
                } else {
                    BarMark(
                        x: .value("Date", item.date, unit: timing == "Week" ? .day : .month),
                        y: .value("Focus Time", item.animate ? item.focusTime : 0)
                    )
                    .foregroundStyle(Color("Color3").gradient)
                }
                
                if isLineChart {
                    AreaMark(
                        x: .value("Date", item.date, unit: timing == "Week" ? .day : .month),
                        y: .value("Focus Time", item.animate ? item.focusTime : 0)
                    )
                    .foregroundStyle(Color("Color3").opacity(0.1).gradient)
                    .interpolationMethod(.catmullRom)
                }
            }
        }
        .chartYScale(domain: 0...(max + 80))
        .frame(height: 300)
        .onAppear {
            
            if timing == "Week" {
                focusTimeData.wrappedValue = viewModel.fetchDataForWeek()
            } else {
                focusTimeData.wrappedValue = viewModel.fetchDataForMonth()
            }
            
            viewModel.animateGraph(fromChange: true, focusTimeData: focusTimeData)
        }
    }

}


struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
