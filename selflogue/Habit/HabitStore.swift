
/// `HabitStore` is a class that represents the Model in the Model-View-ViewModel (MVVM) architecture.
/// It encapsulates the habit data and provides methods for manipulating the data.
///
/// The `HabitStore` serves as the only source for the habit data in the application.
/// It interacts with the underlying Core Data storage and performs CRUD (Create, Read, Update, Delete) operations on the habit objects.
///
/// This class demonstrates the principles of Object-Oriented Programming (OOP) by encapsulating the habit data and related functionality.
/// It exposes properties to access and modify the habit data, and uses the `@Published` property wrapper to notify observers of changes.
///
/// The `HabitStore` is used by the `HabitView` to fetch and delete habits, and by the `AddHabitView` to add or update habits.
/// It acts as the bridge between the View and the persistent storage, ensuring consistency and integrity of the habit data.
///
/// Code implementation inspired by "SwiftUI 3.0 - Habit Tracker App + Core Data - Complex UI - MVVM - CRUD - Xcode 13 - SwiftUI Tutorial" by Kavsoft (2021)
/// Video URL: https://youtu.be/oSF7fSPGmNo


import Combine
import SwiftUI
import CoreData


class HabitStore: ObservableObject {
    
    
    // The array of habits, published to notify observers of changes.
    @Published var habits: [Habit] = []
    
    // Properties for storing habit details.
    @Published var habitTitle: String = ""
    @Published var habitDescription: String = ""
    @Published var habitColor: String = "Color-1"
    @Published var addNewHabit: Bool = false
    @Published var weekDays: [String] = []
    @Published var notificationAccess: Bool = false
    
    // The habit being edited, if any.
    @Published var editHabit: Habit?
    
    // Properties for managing reminders.
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

    // The managed object context for Core Data operations.
    private var managedObjectContext: NSManagedObjectContext
    
    
    // Initializes the HabitStore with the provided managed object context.
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
        fetchHabits()
    }
    
    
    // Fetches the habits from Core Data and updates the `habits` array.
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
    
    
    // Deletes a habit from Core Data.
    func deleteHabit(habit: Habit) {
        managedObjectContext.delete(habit)

        do {
            try managedObjectContext.save()
            fetchHabits()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }

    
    // Restores the edited habit's data to the properties for editing.
    func restoreEditData() {
        
        if let editHabit = editHabit {
            habitTitle = editHabit.habitTitle ?? ""
            habitDescription = editHabit.habitDescription ?? ""
            habitColor = editHabit.habitColor ?? "Card-1"
            weekDays = editHabit.weekDays ?? []
            reminderIsOn = editHabit.reminderIsOn
            reminderTime = editHabit.reminderTime ?? Date()
        }
        
    }
    
    
    // Resets the habit data properties to their default values.
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
    
    
    // Adds or updates a habit in Core Data and returns the habit object.
    func addHabit(context: NSManagedObjectContext) async -> Habit? {
        
        var habit: Habit!
        if let editHabit = editHabit {
            habit = editHabit
        } else {
            habit = Habit(context: managedObjectContext)
            habit.id = UUID()
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
            updateReminder(habitId: habit.id!.uuidString)
            return habit
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return nil
    }

    
    // Updates the reminder for a habit using the provided habit ID.
    func updateReminder(habitId: String) {
        
        if reminderIsOn {
            
            let content = UNMutableNotificationContent()
            content.title = "Habit reminder"
            content.body = "It's time to \(habitTitle)!"
            content.sound = .default
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            
            let request = UNNotificationRequest(identifier: habitId, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
            
        } else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habitId])
        }
    }

    
    // Deletes the notification for a habit.
    func deleteNotification(for habit: Habit) {

        guard let habitId = habit.id else {
            print("Error: Habit's id is nil")
            return
        }

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habitId.uuidString])
    }

}
