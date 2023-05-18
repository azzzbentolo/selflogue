//
//  Home.swift
//  Test
//
//  Created by Chew Jun Pin on 18/5/2023.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.managedObjectContext) private var context
    @State private var showAddHabitView = false
    @ObservedObject private var habitStore: HabitStore
    
    init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        habitStore = HabitStore(context: context)
    }
    
    var body: some View {
        VStack {

            ScrollView(habitStore.habits.isEmpty ? .init() : .vertical, showsIndicators: false) {
                VStack(spacing: 15){
                    ForEach(habitStore.habits){habit in
                        habitCardView(habit: habit)
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let habit = habitStore.habits[index]
                            habitStore.deleteHabit(habit: habit)
                        }
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
        .frame(maxHeight: .infinity,alignment: .top)
//        .padding()
    }
    
    @ViewBuilder
    func habitCardView(habit: Habit) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(habit.habitTitle ?? "")
                    .font(.headline)
                Text(habit.habitDescription ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.horizontal, 30)
        .onLongPressGesture {
            self.habitStore.deleteHabit(habit: habit)
        }
    }
}
    

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


