import SwiftUI
import CoreData


/// `AddHabitView` is a SwiftUI View struct that allow users to add new habits or edit existing ones.
///
/// It follows the Model-View-ViewModel (MVVM) architecture in SwiftUI, where it acts as both the View and the ViewModel.
///
/// As a View, it renders the user interface elements and captures user input for habit details such as title, description, color, frequency, and reminder settings.
///
/// As a ViewModel, it encapsulates the state and behavior related to habit data and interacts with the underlying Model, `HabitStore`.
///
/// It manages the presentation of habit data in the View, synchronizes user input with the ViewModel state, and triggers appropriate actions in the Model.
///
/// The `AddHabitView` also utilizes the principles of Object-Oriented Programming (OOP) by encapsulating related properties (such as state variables, observed objects) and behavior (methods) within the struct.
///
/// It establishes a connection with the `HabitStore` through the `@ObservedObject` property wrapper, which allows it to observe changes in the underlying data and propagate those changes to the View.
///
/// This enables data binding between the View and the ViewModel, ensuring that the user interface is always up to date with the underlying habit data.
///
/// The `AddHabitView` also interacts with the `HabitStore` to perform data operations such as adding and editing habits. It uses the `@Binding` property wrapper to establish a two-way binding with the `showAddHabitView` property in the parent view, `HabitView`.
///
/// This allows it to control the presentation of the `AddHabitView` and communicate changes back to the parent view.
///
/// Overall, the `AddHabitView` demonstrates the principles of the MVVM architecture by separating the concerns of data management (ViewModel) and user interface (View).


struct AddHabitView: View {
    
    
    @Binding var showAddHabitView: Bool
    @Environment(\.self) var env
    @ObservedObject var habitStore: HabitStore
    @State private var showAlert = false
    @State private var showEmptyFieldsAlert = false
    
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 15) {
                
                TextField("Title", text: $habitStore.habitTitle)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color("TFBG").opacity(0.4),in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                
                TextField("Title Description", text: $habitStore.habitDescription)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color("TFBG").opacity(0.4),in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                
                HStack(spacing: 0){
                    ForEach(1...7,id: \.self){index in
                        let color = "Color-\(index)"
                        Circle()
                            .fill(Color(color))
                            .frame(width: 30, height: 30)
                            .overlay(content: {
                                if color == habitStore.habitColor{
                                    Image(systemName: "checkmark")
                                        .font(.caption.bold())
                                        .foregroundColor(.white)
                                }
                            })
                            .onTapGesture {
                                withAnimation{
                                    habitStore.habitColor = color
                                }
                            }
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text("Frequency")
                        .font(.callout.bold())
                    
                    let weekDays = Calendar.current.weekdaySymbols
                    
                    HStack(spacing: 10){
                        ForEach(weekDays,id: \.self){day in
                            let index = habitStore.weekDays.firstIndex { value in
                                return value == day
                            } ?? -1
                            
                            Text(day.prefix(2))
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical,12)
                                .foregroundColor(index != -1 ? .white : .primary)
                                .background {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(index != -1 ? Color(habitStore.habitColor) : Color("TFBG").opacity(0.4))
                                }
                                .onTapGesture {
                                    withAnimation {
                                        if index != -1 {
                                            habitStore.weekDays.remove(at: index)
                                        } else {
                                            habitStore.weekDays.append(day)
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.top,15)
                }
                
                Divider()
                    .padding(.vertical,10)
                
                VStack {
                    HStack{
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Reminder")
                                .fontWeight(.semibold)
                            
                            Text("Notification")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                        
                        Toggle(isOn: $habitStore.reminderIsOn) {}
                            .labelsHidden()
                    }
                    
                    if (habitStore.reminderIsOn) {
                        DatePicker("Reminder time", selection: $habitStore.reminderTime, displayedComponents: .hourAndMinute)
                    }
                }
                
                Button("Save Habit") {
                    
                    if habitStore.habitTitle.isEmpty || habitStore.habitDescription.isEmpty {
                        showEmptyFieldsAlert = true
                        
                    } else {
                        Task {
                            if let habit = await habitStore.addHabit(
                                context: env.managedObjectContext) {
                                if self.habitStore.reminderIsOn {
                                    self.scheduleNotification(for: habit)
                                }
                                env.dismiss()
                            }
                        }
                        self.showAddHabitView = false
                    }
                }
                .disabled(habitStore.habitTitle.isEmpty || habitStore.habitDescription.isEmpty)
                .navigationBarItems(leading: Button("Delete") {
                    showAlert = true
                }.alert(isPresented: $showAlert) {
                    
                    Alert(
                        title: Text("Delete Habit"),
                        message: Text("Are you sure you want to delete this habit?"),
                        primaryButton: .destructive(Text("Delete")) {
                            if let habitToDelete = habitStore.editHabit {
                                habitStore.deleteNotification(for: habitToDelete)
                                habitStore.deleteHabit(habit: habitToDelete)
                            }
                            showAddHabitView = false
                        },
                        secondaryButton: .cancel()
                    )
                }, trailing: Button("Cancel") {
                    self.showAddHabitView = false
                })
                .tint(.primary)
            }
            .frame(maxHeight: .infinity,alignment: .top)
            .padding()
        }
    }
    
    
    func scheduleNotification(for habit: Habit) {
        
        let content = UNMutableNotificationContent()
        content.title = "Habit reminder"
        content.body = "It's time to \(habit.habitTitle ?? "")"
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: habit.reminderTime!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: habit.id!.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
}






