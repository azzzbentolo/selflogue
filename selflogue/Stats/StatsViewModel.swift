
/// `StatsViewModel` is the ViewModel in the MVVM (Model-View-ViewModel) architecture, in accordance with SwiftUI's design patterns.
///
/// This class is responsible for handling and managing the business logic related to retrieving and managing statistical data related to user's focus time, specifically for weekly and monthly timeframes.
///
/// The ViewModel interacts with the Core Data context via `FocusTimeManager` to fetch and format the focus time data that is stored in the persistent store.
///
/// `StatsViewModel` offers methods for fetching data for a week, fetching data for a month and animating the graph. These methods encapsulate the business logic required to manage the data flow to the `StatsView` - separating concerns and improving code readability and reusability.
///
/// As an implementation of MVVM, `StatsViewModel` provides a clear separation of concerns. It ensures that the `StatsView` remains clean and free of business logic, instead focusing on presenting the data to the user.
///
/// In addition, `StatsViewModel` represents good OOP (Object-Oriented Programming) design. It encapsulates data and methods related to managing focus time statistics, and hides the internal implementation details. This leads to increased modularity and a clear, intuitive structure, with each class and method having a single, well-defined responsibility.


import Foundation
import SwiftUI
import Charts


// StatsViewModel is the model responsible for handling the logic related to the data displayed on the StatsView.
class StatsViewModel: ObservableObject {
    
    
    //MARK: - Properties
    
    // Published variables to hold and notify changes in focus time data for the week and month.
    @Published var focusTimeDataWeek = [FocusTimeData]()
    @Published var focusTimeDataMonth = [FocusTimeData]()
    
    // Published variables to hold the currently active items for the week and month view.
    @Published var currentActiveItemWeek: FocusTimeData?
    @Published var currentActiveItemMonth: FocusTimeData?
    
    // Published variable to hold the current tab view ("Week" or "Month").
    @Published var currentTab: String = "Week"
    
    // Published variable to hold the currently active item.
    @Published var currentActiveItem: FocusTimeData? = nil
    
    // Published variable to hold the state of chart view. Determines if the chart is line chart or not.
    @Published var isLineChart: Bool = false
    
    
    // MARK: - Methods
    
    // Fetches focus time data for the week from CoreData and updates the state
    func fetchFocusTimeDataForWeek() {
        focusTimeDataWeek = self.fetchDataForWeek()
    }
    
    
    // Fetches focus time data for the month from CoreData and updates the state
    func fetchFocusTimeDataForMonth() {
        focusTimeDataMonth = self.fetchDataForMonth()
    }
    
    
    // Fetches the data for a week. It iterates through each day of the week and collects focus time data for each day.
    func fetchDataForWeek() -> [FocusTimeData] {
        
        var focusTimeData = [FocusTimeData]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return focusTimeData
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let focusTimeManager = FocusTimeManager(context: context)
        
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Start from Monday
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else {
            return focusTimeData
        }
        
        for index in 0..<7 {
            let date = calendar.date(byAdding: .day, value: index, to: startOfWeek)!
            let focusTime = focusTimeManager.getFocusTime(for: date)
            focusTimeData.append(FocusTimeData(date: date, focusTime: Double(focusTime)))
        }
        
        return focusTimeData
    }


    // Fetches the data for a month. It iterates through each month of the year and collects focus time data for each month.
    func fetchDataForMonth() -> [FocusTimeData] {
        
        var focusTimeData = [FocusTimeData]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return focusTimeData
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let focusTimeManager = FocusTimeManager(context: context)
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        
        for month in 1...12 {
            let dateComponents = DateComponents(year: year, month: month)
            guard let date = calendar.date(from: dateComponents) else { continue }
            let focusTime = focusTimeManager.getFocusTimeForMonth(for: date)
            focusTimeData.append(FocusTimeData(date: date, focusTime: Double(focusTime)))
        }
        
        return focusTimeData
    }


    // Animates the graph by enabling animation on each data point in the graph with a staggered delay.
    func animateGraph(fromChange: Bool = false, focusTimeData: Binding<[FocusTimeData]>) {
        
        for (index, _) in focusTimeData.wrappedValue.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
                withAnimation(fromChange ? .easeInOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    focusTimeData.wrappedValue[index].animate = true
                }
            }
        }
        
    }
}
