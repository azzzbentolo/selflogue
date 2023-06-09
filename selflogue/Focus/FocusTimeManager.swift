
/// `FocusTimeManager` is responsible for managing the focus time sessions and persisting the focus time data using Core Data.
/// It follows the MVVM (Model-View-ViewModel) architecture in SwiftUI.
///
/// It acts as the ViewModel, encapsulating the business logic related to focus time management.
/// The class communicates with the Core Data stack and provides methods to start/end focus sessions, increment focus time, and retrieve focus time data.
///
/// `FocusTimeManager` interacts with the Core Data context to fetch and update the focus time data stored in the persistent store.
///
/// Overall, `FocusTimeManager` plays a crucial role in managing and tracking the focus time sessions and providing data to the FocusSwiftUIView.
///
/// `FocusTimeManager` encapsulates the functionality related to managing focus time data and hides the internal implementation details, which makes use of good OOP.
///
///
import Foundation
import CoreData


class FocusTimeManager: ObservableObject {

    
    private var context: NSManagedObjectContext
    private var sessionStartDate: Date?
    
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    // Start a focus session by setting the session start date.
    func startFocusSession() {
        sessionStartDate = Date()
    }
    
    
    // End a focus session and calculate the elapsed time.
    // Increment the focus time with the elapsed time.
    // Returns the elapsed time of the focus session.
    func endFocusSession() -> TimeInterval? {
        guard let start = sessionStartDate else { return nil }
        let elapsedTime = Date().timeIntervalSince(start)
        incrementFocusTime(by: elapsedTime)
        return elapsedTime
    }
    

    // Increment the focus time for the current day.
    func incrementFocusTime(by elapsedTime: TimeInterval) {
        let today = Calendar.current.startOfDay(for: Date())
        let request: NSFetchRequest<FocusTime> = FocusTime.fetchRequest()
        request.predicate = NSPredicate(format: "date = %@", today as NSDate)
        
        do {
            let results = try context.fetch(request)
            if let focusTime = results.first {
                focusTime.totalTime += Int64(elapsedTime)
            } else {
                let newFocusTime = FocusTime(context: context)
                newFocusTime.date = today
                newFocusTime.totalTime = Int64(elapsedTime)
            }
            
            try context.save()
            
        } catch {
            print("Failed to increment focus time: \(error)")
        }
    }


    // Get the total focus time for a specific date.
    func getFocusTime(for date: Date) -> Int {
        
        let day = Calendar.current.startOfDay(for: date)
        let request: NSFetchRequest<FocusTime> = FocusTime.fetchRequest()
        request.predicate = NSPredicate(format: "date = %@", day as NSDate)
        
        do {
            let results = try context.fetch(request)
            return Int(results.first?.totalTime ?? 0)
        } catch {
            print("Failed to fetch focus time: \(error)")
            return 0
        }
        
    }
    
    
    // Get the total focus time for a specific month.
    func getFocusTimeForMonth(for date: Date) -> Int {
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local

        let components = calendar.dateComponents([.year, .month], from: date)
        guard let startOfMonth = calendar.date(from: components)
        else { return 0 }

        var addComponents = DateComponents()
        addComponents.month = 1
        addComponents.day = -1
        guard let endOfMonth = calendar.date(byAdding: addComponents, to: startOfMonth)
        else { return 0 }

        let request: NSFetchRequest<FocusTime> = FocusTime.fetchRequest()
        request.predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", startOfMonth as NSDate, endOfMonth as NSDate)

        do {
            let results = try context.fetch(request)
            return results.reduce(0) { $0 + Int($1.totalTime) }
        } catch {
            print("Failed to fetch focus time for month: \(error)")
            return 0
        }
    }

}
