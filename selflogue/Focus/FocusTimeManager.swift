import Foundation
import CoreData

class FocusTimeManager: ObservableObject {

    
    private var context: NSManagedObjectContext
    private var sessionStartDate: Date?
    
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    func startFocusSession() {
        sessionStartDate = Date()
    }
    
    
    func endFocusSession() -> TimeInterval? {
        guard let start = sessionStartDate else { return nil }
        let elapsedTime = Date().timeIntervalSince(start)
        incrementFocusTime(by: elapsedTime)
        return elapsedTime
    }
    

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
    
    
    func getFocusTimeForMonth(for date: Date) -> Int {
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local

        let components = calendar.dateComponents([.year, .month], from: date)
        guard let startOfMonth = calendar.date(from: components) else { return 0 }

        var addComponents = DateComponents()
        addComponents.month = 1
        addComponents.day = -1
        guard let endOfMonth = calendar.date(byAdding: addComponents, to: startOfMonth) else { return 0 }

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
