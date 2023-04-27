//
//  TimerSwiftUIView.swift
//  selflogue
//
//  Created by Chew Jun Pin on 27/4/2023.
//

import SwiftUI


let timer = Timer
    .publish(every: 1, on: .main, in: .common)
    .autoconnect()


struct Clock: View {
    
    var counter: Int
    var countTo: Int
    
    var body: some View {
        
        VStack {
            Text(counterToMinutes())
                .font(.custom("Lato-Regular", size: 55))
                .fontWeight(.black)
        }
    }
    
    func counterToMinutes() -> String {
        let currentTime = countTo - counter
        let seconds = currentTime % 60
        let minutes = Int(currentTime / 60)
        
        return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
    }
    
}


struct ProgressTrack: View {
    
    var body: some View {
        
        Circle()
            .fill(Color.clear)
            .frame(width: 250, height: 250)
            .overlay(
                Circle().stroke(Color("Color1"), lineWidth: 20)
                    
        )
    }
}


struct ProgressBar: View {
    
    var counter: Int
    var countTo: Int
    
    let gradient = AngularGradient(
        gradient: Gradient(colors: [Color("Color1"), Color("Color3")]),
        center: .center,
        startAngle: .degrees(360),
        endAngle: .degrees(0))
    
    var body: some View {
        
        Circle()
            .fill(Color.clear)
            .frame(width: 250, height: 250)
            .overlay(
                Circle().trim(from: 0, to: progress())
                    .stroke(gradient,
                        style: StrokeStyle(
                            lineWidth: 20,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    ).rotationEffect(.degrees(-90))
                    .animation(
                .easeInOut(duration: 1.5)
                ,value: 0.0)
        )
    }
    
    func completed() -> Bool {
        return progress() == 1
    }
    
    func progress() -> CGFloat {
        return (CGFloat(counter) / CGFloat(countTo))
    }
}


struct TimerSwiftUIView: View {
    
    @State var counter: Int = 0
    var countTo: Int = 30
    
    var body: some View {
        VStack{
            ZStack{
                ProgressTrack()
                ProgressBar(counter: counter, countTo: countTo)
                Clock(counter: counter, countTo: countTo)
            }
        }.onReceive(timer) { time in
            if (self.counter < self.countTo) {
                self.counter += 1
            }
        }
    }
}


struct TimerSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        TimerSwiftUIView()
    }
}

//import SwiftUI


//struct TimerSwiftUIView: View {
//
//    @State private var timeRemaining = 10
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//
//    var body: some View {
//        Text("\(timeRemaining)")
//            .font(.largeTitle)
//            .onReceive(timer) { _ in
//                if timeRemaining > 0 {
//                    timeRemaining -= 1
//                }
//            }
//    }
//}
//
//
//struct TimerSwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimerSwiftUIView()
//    }
//}
