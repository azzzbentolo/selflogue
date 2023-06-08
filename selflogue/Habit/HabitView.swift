//
//  Home.swift
//  Selflogue
//
//  Created by Chew Jun Pin on 18/5/2023.
//

import SwiftUI

struct HabitView: View {
    
    @Environment(\.managedObjectContext) private var context
    @State private var showAddHabitView = false
    @ObservedObject private var habitStore: HabitStore
    @State private var showAlert = false
    
    init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        habitStore = HabitStore(context: context)
    }
    
    var body: some View {
        VStack {
            
            // MAKING ADD BUTTON CENTER WHEN HABITS EMPTY
            ScrollView(habitStore.habits.isEmpty ? .init() : .vertical, showsIndicators: false) {
                VStack(spacing: 15){
                    ForEach(habitStore.habits){habit in
                        HabitCardView(habit: habit)
                    }
                }
                
                // MARK: Add Habit Button
                Button {
                    self.showAddHabitView = true
                } label: {
                    Label {
                        Text("New habit")
                    } icon: {
                        Image(systemName: "plus.circle")
                    }
                    .font(.callout.bold())
                    .foregroundColor(.black)
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
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    func HabitCardView(habit: Habit)->some View{
        VStack(spacing: 6){
            HStack{
                Text(habit.habitTitle ?? "")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Image(systemName: "bell.badge.fill")
                    .font(.callout)
                    .foregroundColor(Color(habit.habitColor ?? "Color-1"))
                    .scaleEffect(0.9)
                    .opacity(habit.reminderIsOn ? 1 : 0)
                
                Spacer()
                
                let count = (habit.weekDays?.count ?? 0)
                Text(count == 7 ? "Everyday" : "\(count) times a week")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal,10)
            
            // MARK: Displaying Current Week and Marking Active Dates of Habit
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
                        // MARK: Limiting to First 3 letters
                        Text(item.0.prefix(3))
                            .font(.caption)
                            .foregroundColor(.gray)
                        
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
            // MARK: Editing Habit
            habitStore.editHabit = habit
            habitStore.restoreEditData()
            self.showAddHabitView.toggle()
        }
        .onLongPressGesture { // Long press gesture
            showAlert = true
        }
        .alert(isPresented: $showAlert) { // Alert
            Alert(
                title: Text("Delete Habit"),
                message: Text("Are you sure you want to delete this habit?"),
                primaryButton: .destructive(Text("Delete")) {
                    habitStore.deleteHabit(habit: habit)
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    
    
    
    // MARK: Formatting Date
    func getDate(date: Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        
        return formatter.string(from: date)
    }

    
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


