import Combine
import SwiftUI
import CoreData


class HabitStore: ObservableObject {
    
    @Published var habits: [Habit] = []
    @Published var habitTitle: String = ""
    @Published var habitDescription: String = ""
    @Published var habitColor: String = "Color-1"
    @Published var reminderIsOn: Bool = false {
        didSet {
            if let editHabit = editHabit {
                if reminderIsOn {
                    updateReminder(habitId: editHabit.id!.uuidString)
                } else {
                    deleteNotification(for: editHabit)
                }
            }
        }
    }

    @Published var reminderTime: Date = Date() {
        didSet {
            if reminderIsOn, let habitId = editHabit?.id?.uuidString {
                updateReminder(habitId: habitId)
            }
        }
    }

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
        DispatchQueue.main.async {
            let request: NSFetchRequest<Habit> = Habit.fetchRequest()

            do {
                self.habits = try self.managedObjectContext.fetch(request)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func addHabit(context: NSManagedObjectContext) async -> Bool {
        var habit: Habit!
        if let editHabit = editHabit {
            habit = editHabit
        } else {
            habit = Habit(context: managedObjectContext)
            habit.id = UUID()  // Assign a new UUID when creating a new habit
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

    
    func deleteHabit(habit: Habit) {
        managedObjectContext.delete(habit)

        do {
            try managedObjectContext.save()
            fetchHabits()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }

    
    // MARK: Restoring Edit Data
    func restoreEditData(){
        if let editHabit = editHabit {
            habitTitle = editHabit.habitTitle ?? ""
            habitDescription = editHabit.habitDescription ?? ""
            habitColor = editHabit.habitColor ?? "Card-1"
            weekDays = editHabit.weekDays ?? []
            reminderIsOn = editHabit.reminderIsOn
            reminderTime = editHabit.reminderTime ?? Date()
        }
    }
    
    
    func resetHabitData() {
        self.habitTitle = ""
        self.habitDescription = ""
        self.habitColor = "Color-1"
        self.reminderIsOn = false
        self.reminderTime = Date()
        self.addNewHabit = false
        self.weekDays = []
        self.editHabit = nil
    }
    
    
    func addHabit(context: NSManagedObjectContext) async -> Habit? {
        var habit: Habit!
        if let editHabit = editHabit {
            habit = editHabit
        } else {
            habit = Habit(context: managedObjectContext)
            habit.id = UUID()  // Assign a new UUID when creating a new habit
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

            // Update reminder after habit is saved
            updateReminder(habitId: habit.id!.uuidString)

            return habit
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    
    func updateReminder(habitId: String) {
        if reminderIsOn {
            // Schedule notification
            let content = UNMutableNotificationContent()
            content.title = "Habit reminder"
            content.body = "It's time to \(habitTitle)"
            content.sound = .default
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            
            let request = UNNotificationRequest(identifier: habitId, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        } else {
            // Cancel notification
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habitId])
        }
    }

    
    
    func deleteNotification(for habit: Habit) {
        // Safely unwrap habit's id
        guard let habitId = habit.id else {
            print("Error: Habit's id is nil")
            return
        }

        // Use the habit's id to delete the corresponding notification
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habitId.uuidString])
    }





}
