//
//  SwiftUIView.swift
//  selflogue
//
//  Created by Chew Jun Pin on 8/6/2023.
//

import SwiftUI
import Charts


struct FocusTimeData: Identifiable {
    let id = UUID()
    var date: Date
    let focusTime: Double
    var animate: Bool = false
}


private func fetchFocusTimeDataForWeek() -> [FocusTimeData] {
    
    var focusTimeData = [FocusTimeData]()
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return focusTimeData
    }
    
    let context = appDelegate.persistentContainer.viewContext
    let focusTimeManager = FocusTimeManager(context: context)
    
    var calendar = Calendar.current
    calendar.firstWeekday = 2 // Start from Monday
    guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else {
        return focusTimeData
    }
    
    for index in 0..<7 {
        let date = calendar.date(byAdding: .day, value: index, to: startOfWeek)!
        let focusTime = focusTimeManager.getFocusTime(for: date)
        focusTimeData.append(FocusTimeData(date: date, focusTime: Double(focusTime)))
    }
    
    return focusTimeData
}


private func fetchFocusTimeDataForMonth() -> [FocusTimeData] {
    
    var focusTimeData = [FocusTimeData]()
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return focusTimeData
    }
    
    let context = appDelegate.persistentContainer.viewContext
    let focusTimeManager = FocusTimeManager(context: context)
    
    let calendar = Calendar.current
    let year = calendar.component(.year, from: Date())
    
    for month in 1...12 {
        let dateComponents = DateComponents(year: year, month: month)
        guard let date = calendar.date(from: dateComponents) else { continue }
        let focusTime = focusTimeManager.getFocusTimeForMonth(for: date)
        focusTimeData.append(FocusTimeData(date: date, focusTime: Double(focusTime)))
    }
    
    return focusTimeData
}



struct StatsView: View {
    
    //MARK: State Chart Data For Animation Changes
    @State var focusTimeDataWeek = [FocusTimeData]()
    @State var focusTimeDataMonth = [FocusTimeData]()
    @State var currentActiveItemWeek: FocusTimeData?
    @State var currentActiveItemMonth: FocusTimeData?
    @State var currentTab: String = "Week"
    @State var currentActiveItem: FocusTimeData? = nil
    @State var plotWidth: CGFloat = 0
    @State var isLineChart: Bool = false
    
    
    var body: some View {
        VStack{
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Time Focused")
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Picker("", selection: $currentTab) {
                        Text("Week").tag("Week")
                        Text("Month").tag("Month")
                    }
                    .pickerStyle(.segmented)
                    .padding(.leading, 50)
                }
                .padding(.horizontal, 0)
                
                if currentTab == "Week" {
                    let totalValue = focusTimeDataWeek.reduce(0.0) { partialResult, item in
                        item.focusTime + partialResult
                    }
                    
                    Text(String(totalValue))
                        .font(.largeTitle.bold())
                    
                    AnimatedChart(time: "Week", focusTimeData: $focusTimeDataWeek, currentActiveItem: $currentActiveItemWeek)
                    
                } else if currentTab == "Month" {
                    let totalValue = focusTimeDataMonth.reduce(0.0) { partialResult, item in
                        item.focusTime + partialResult
                    }
                    
                    Text(String(totalValue))
                        .font(.largeTitle.bold())
                    
                    AnimatedChart(time: "Month", focusTimeData: $focusTimeDataMonth, currentActiveItem: $currentActiveItemMonth)
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.white.shadow(.drop(radius: 2)))
            }
            Toggle("Line Chart", isOn: $isLineChart)
                                .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
    }

    
    
    // MARK: Create animated chart
    @ViewBuilder
    func AnimatedChart(time: String, focusTimeData: Binding<[FocusTimeData]>, currentActiveItem: Binding<FocusTimeData?>) -> some View {
        
        let max = focusTimeData.wrappedValue.max {item1, item2 in
            return item2.focusTime > item1.focusTime
        }?.focusTime ?? 0
        let timing: String = time
        
        Chart {
            ForEach(focusTimeData.wrappedValue) { item in
                
                // MARK: Line and bar charts
                if isLineChart {
                    LineMark(
                        x: .value("Date", item.date, unit: timing == "Week" ? .day : .month),
                        y: .value("Focus Time", item.animate ? item.focusTime : 0)
                    )
                    .foregroundStyle(Color.blue.gradient)
                    .interpolationMethod(.catmullRom)
                } else {
                    BarMark(
                        x: .value("Date", item.date, unit: timing == "Week" ? .day : .month),
                        y: .value("Focus Time", item.animate ? item.focusTime : 0)
                    )
                    .foregroundStyle(Color.blue.gradient)
                }
                
                if isLineChart {
                    AreaMark(
                        x: .value("Date", item.date, unit: timing == "Week" ? .day : .month),
                        y: .value("Focus Time", item.animate ? item.focusTime : 0)
                    )
                    .foregroundStyle(Color.blue.opacity(0.1).gradient)
                    .interpolationMethod(.catmullRom)
                }
                
                if let currentActiveItem = currentActiveItem.wrappedValue, currentActiveItem.id == item.id {
                    RuleMark(x: .value("Date", currentActiveItem.date))
                    
                        .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                        .annotation(position: .top) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Focus Time")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Text(String(currentActiveItem.focusTime))
                                    .font(.title3.bold())
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(.white.shadow(.drop(radius: 2)))
                            }
                        }
                }
            }
        }
        .chartYScale(domain: 0...(max + 80))
        .chartOverlay(content: {proxy in
            GeometryReader { innerProxy in
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let location = value.location
                                if let date: Date = proxy.value(atX: location.x) {
                                    let calendar = Calendar.current
                                    let day = calendar.component(.day, from: date)
                                    if let currentItem = focusTimeData.wrappedValue.first(where: { item in
                                        calendar.component(.day, from: item.date) == day
                                    }) {
                                        currentActiveItem.wrappedValue = currentItem
                                    }
                                }
                            }
                            .onEnded { value in
                                currentActiveItem.wrappedValue = nil
                            }
                    )
            }
            
        })
        .frame(height: 300)
        .onAppear {
            if timing == "Week" {
                focusTimeData.wrappedValue = fetchFocusTimeDataForWeek()
            } else {
                focusTimeData.wrappedValue = fetchFocusTimeDataForMonth()
            }
            animateGraph(fromChange: true, focusTimeData: focusTimeData)
        }
    }
    
    // MARK: Animating Graph
    func animateGraph(fromChange: Bool = false, focusTimeData: Binding<[FocusTimeData]>) {
        for (index, _) in focusTimeData.wrappedValue.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
                withAnimation(fromChange ? .easeInOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    focusTimeData.wrappedValue[index].animate = true
                }
            }
        }
    }
    
}


struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
