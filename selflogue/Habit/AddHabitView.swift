import SwiftUI
import CoreData


struct AddHabitView: View {
    
    @Binding var showAddHabitView: Bool
    @Environment(\.self) var env
    @ObservedObject var habitStore: HabitStore
    @State private var showAlert = false
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 15) {
                
                // MARK: Text Field for Title and Description
                TextField("Title", text: $habitStore.habitTitle)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color("TFBG").opacity(0.4),in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                
                TextField("Title Description", text: $habitStore.habitDescription)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color("TFBG").opacity(0.4),in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                
                // MARK: Choose Color
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
                // MARK: Frequency Selection
                VStack(alignment: .leading, spacing: 6) {
                    Text("Frequency")
                        .font(.callout.bold())
                    let weekDays = Calendar.current.weekdaySymbols
                    HStack(spacing: 10){
                        ForEach(weekDays,id: \.self){day in
                            let index = habitStore.weekDays.firstIndex { value in
                                return value == day
                            } ?? -1
                            // MARK: Limiting to First 2 Letters
                            Text(day.prefix(2))
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical,12)
                                .foregroundColor(index != -1 ? .white : .primary)
                                .background{
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(index != -1 ? Color(habitStore.habitColor) : Color("TFBG").opacity(0.4))
                                }
                                .onTapGesture {
                                    withAnimation{
                                        if index != -1{
                                            habitStore.weekDays.remove(at: index)
                                        }else{
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
                
                // Hiding If Notification Access is Rejected
                // MARK: Set Reminder
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
                    Task{
                        if let habit = await habitStore.addHabit(
                            context: env.managedObjectContext){
                            if self.habitStore.reminderIsOn {
                                self.scheduleNotification(for: habit)
                            }
                            env.dismiss()
                        }
                    }
                    self.showAddHabitView = false
                }
                .navigationBarItems(leading: // Add this leading block
                                    Button("Delete") {
                    showAlert = true // set alert state to true
                }.alert(isPresented: $showAlert) { // Alert
                    Alert(
                        title: Text("Delete Habit"),
                        message: Text("Are you sure you want to delete this habit?"),
                        primaryButton: .destructive(Text("Delete")) {
                            if let habitToDelete = habitStore.editHabit {
                                habitStore.deleteNotification(for: habitToDelete)
                                habitStore.deleteHabit(habit: habitToDelete)
                            } // call the delete function
                            showAddHabitView = false // dismiss the view
                        },
                        secondaryButton: .cancel()
                    )
                },
                                    trailing:
                                        Button("Cancel") {
                    self.showAddHabitView = false
                }
                )
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

        // Use the habit's id as the identifier of the notification request
        let request = UNNotificationRequest(identifier: habit.id!.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

}






