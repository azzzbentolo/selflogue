import SwiftUI
import CoreData


struct AddHabitView: View {
    
    @Binding var showAddHabitView: Bool
    @Environment(\.self) var env
    @ObservedObject var habitStore: HabitStore


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
                    ForEach(1...7,id: \.self) {index in
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
                    .padding(.vertical,10)
                
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
                        if await habitStore.addHabit(
                            context: env.managedObjectContext){
                                env.dismiss()
                        }
                    }
                    if self.habitStore.reminderIsOn {
                        self.scheduleNotification()
                    }
                    self.showAddHabitView = false
                }
                .navigationBarItems(trailing:
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

    
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Habit reminder"
        content.body = "It's time to \(habitStore.habitTitle)"
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: habitStore.reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}





    
