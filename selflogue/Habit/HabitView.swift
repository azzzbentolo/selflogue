import SwiftUI


/// `HabitView` is a SwiftUI View struct that represents the main view of habits.
/// It displays a list of habit cards and provides the interface for adding new habits.
///
/// The `HabitView` follows the Model-View-ViewModel (MVVM) architecture, where it acts as both the View and the Controller.
///
/// As a View, it renders the habit cards using the `HabitCardView` subview for each habit in the `habitStore`.
/// It also includes a button to add new habits, which triggers the presentation of the `AddHabitView`.
///
/// The `HabitView` utilizes the `habitStore`, an instance of the `HabitStore` class, as its ViewModel.
/// The `habitStore` manages the habit data and provides methods for manipulating the habits.
///
/// Although the `HabitView` doesn't directly communicate with the `HabitStore` to delete habits, it indirectly interacts with it by setting the `editHabit` property of the `habitStore` to trigger the presentation of the `AddHabitView` for editing.
///
/// Overall, the `HabitView` plays a crucial role in displaying and managing the list of habits, and serves as the primary user interface for viewing and adding habits in the application.


// This struct represents the SwiftUI view of Habit.
struct HabitView: View {
    
    // The managed object context provided by the environment.
    @Environment(\.managedObjectContext) private var context
    
    // Whether to show the add habit view or not.
    @State private var showAddHabitView = false
    
    // The observed object to manage the habit store.
    @ObservedObject private var habitStore: HabitStore
    
    // Whether to show an alert or not.
    @State private var showAlert = false
    
    // Initializes the HabitView.
    init() {
        // Fetching the managed object context from the AppDelegate.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Initializing the habit store with the context.
        habitStore = HabitStore(context: context)
    }
    
    
    // The body of the view.
    var body: some View {
        
        VStack {
            ScrollView(habitStore.habits.isEmpty ? .init() : .vertical, showsIndicators: false) {
                VStack(spacing: 15){
                    ForEach(habitStore.habits){habit in
                        HabitCardView(habit: habit)
                    }
                }
                
                Button {
                    self.habitStore.resetHabitData()
                    self.showAddHabitView = true
                } label: {
                    Label {
                        Text("New habit")
                    } icon: {
                        Image(systemName: "plus.circle")
                    }
                    .font(.callout.bold())
                    .tint(.primary)
                }
                .padding(.top,15)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .sheet(isPresented: $showAddHabitView) {
                    AddHabitView(showAddHabitView: self.$showAddHabitView, habitStore: self.habitStore)
                        .preferredColorScheme(.light)
                }
             }
            .padding(.vertical)
        }
        .navigationBarHidden(true)
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    
    @ViewBuilder
    // HabitCardView represents a single habit card.
    func HabitCardView(habit: Habit)->some View {
        
        VStack(spacing: 6){
            HStack{
                
                // Displaying the habit title.
                Text(habit.habitTitle ?? "")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                // Displaying a bell icon if the reminder is on.
                Image(systemName: "bell.badge.fill")
                    .font(.callout)
                    .foregroundColor(Color(habit.habitColor ?? "Color-1"))
                    .scaleEffect(0.9)
                    .opacity(habit.reminderIsOn ? 1 : 0)
                
                Spacer()
                
                // Displaying the frequency of the habit.
                let count = (habit.weekDays?.count ?? 0)
                Text(count == 7 ? "Everyday" : "\(count) times a week")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal,10)
            
            // Displaying the current week and marking active dates of the habit.
            let calendar = Calendar.current
            let currentWeek = calendar.dateInterval(of: .weekOfMonth, for: Date())
            let symbols = calendar.weekdaySymbols
            let startDate = currentWeek?.start ?? Date()
            let activeWeekDays = habit.weekDays ?? []
            let activePlot = symbols.indices.compactMap { index -> (String,Date) in
                let currentDate = calendar.date(byAdding: .day, value: index, to: startDate)
                return (symbols[index],currentDate!)
            }
            
            HStack(spacing: 0){
                ForEach(activePlot.indices,id: \.self){index in
                    let item = activePlot[index]
                    
                    VStack(spacing: 6){

                        // Displaying the weekday abbreviation.
                        Text(item.0.prefix(3))
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        // Displaying the date and marking it as active if it matches the habit's active weekdays.
                        let status = activeWeekDays.contains { day in
                            return day == item.0
                        }
                        
                        Text(getDate(date: item.1))
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .padding(8)
                            .foregroundColor(status ? .white : .primary)
                            .background{
                                Circle()
                                    .fill(Color(habit.habitColor ?? "Card-1"))
                                    .opacity(status ? 1 : 0)
                            }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top,15)
        }
        .padding(.vertical)
        .padding(.horizontal, 20)
        .background{
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color("TFBG").opacity(0.5))
                .padding(.horizontal, 20)
        }
        .onTapGesture {
            // Set the selected habit to the habit store's editHabit property and show the add habit view.
            habitStore.editHabit = habit
            habitStore.restoreEditData()
            self.showAddHabitView.toggle()
        }
    }
    
    
    // Formats a date into a string representation.
    func getDate(date: Date)->String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: date)
        
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HabitView()
    }
}


