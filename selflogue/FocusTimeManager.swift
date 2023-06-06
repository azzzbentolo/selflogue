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
}
