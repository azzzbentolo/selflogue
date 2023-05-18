import Combine
import SwiftUI
import CoreData


class HabitStore: ObservableObject {
    
    @Published var habits: [Habit] = []
    @Published var habitTitle: String = ""
    @Published var habitDescription: String = ""
    @Published var habitColor: String = "Color-1"
    @Published var reminderIsOn: Bool = false
    @Published var reminderTime: Date = Date()
    @Published var addNewHabit: Bool = false

    private var managedObjectContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
        fetchHabits()
    }
    
    private func fetchHabits() {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        
        do {
            self.habits = try managedObjectContext.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func addHabit(context: NSManagedObjectContext) async -> Bool {
//        var habit: Habit!
        let habit = Habit(context: managedObjectContext)
        habit.habitTitle = habitTitle
        habit.habitDescription = habitDescription
        habit.habitColor = habitColor
        habit.reminderIsOn = reminderIsOn
        habit.reminderTime = reminderTime

        do {
            try managedObjectContext.save()
            fetchHabits()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return false
    }

    
    func deleteHabit(habit: Habit) {
        managedObjectContext.delete(habit)

        do {
            try managedObjectContext.save()
            fetchHabits()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
}
