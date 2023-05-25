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
    @Published var weekDays: [String] = []
    
    @Published var notificationAccess: Bool = false
    
    // MARK: Editing Habit
    @Published var editHabit: Habit?

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
        var habit: Habit!
        if let editHabit = editHabit {
            habit = editHabit
        } else {
            habit = Habit(context: managedObjectContext)
        }
        habit.habitTitle = habitTitle
        habit.habitDescription = habitDescription
        habit.habitColor = habitColor
        habit.reminderIsOn = reminderIsOn
        habit.reminderTime = reminderTime
        habit.weekDays = weekDays

        do {
            try managedObjectContext.save()
            fetchHabits()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return false
    }

//    func deleteHabit(context: NSManagedObjectContext)->Bool{
//        if let editHabit = editHabit {
//            if editHabit.reminderIsOn{
//                // Removing All Pending Notifications
//                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: editHabit.notificationIDs ?? [])
//            }
//            context.delete(editHabit)
//            if let _ = try? context.save(){
//                return true
//            }
//        }
//
//        return false
//    }
    
    
    func deleteHabit(habit: Habit) {
        managedObjectContext.delete(habit)

        do {
            try managedObjectContext.save()
            fetchHabits()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
//    func deleteHabit() {
//        guard let habit = editHabit else { return }
//
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        context.delete(habit)
//
//        do {
//            try context.save()
//            fetchHabits()
//        } catch let error as NSError {
//            print("Could not delete. \(error), \(error.userInfo)")
//        }
//    }
    
    
    // MARK: Restoring Edit Data
    func restoreEditData(){
        if let editHabit = editHabit {
            habitTitle = editHabit.habitTitle ?? ""
            habitColor = editHabit.habitColor ?? "Card-1"
            weekDays = editHabit.weekDays ?? []
            reminderIsOn = editHabit.reminderIsOn
            reminderTime = editHabit.reminderTime ?? Date()
        }
    }
}
