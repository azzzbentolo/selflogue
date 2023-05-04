//
//  TimerSwiftUIView.swift
//  selflogue
//
//  Created by Chew Jun Pin on 27/4/2023.
//

import SwiftUI
import AVFoundation


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
        gradient: Gradient(colors: [Color("Color3"), Color("Color1")]),
        center: .center,
        startAngle: .degrees(360),
        endAngle: .degrees(0))
    
    var body: some View {
        Circle()
            .fill(Color.clear)
            .frame(width: 250, height: 250)
            .overlay(
                Circle().trim(from: 1 - progress(), to: 1)
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
        return (CGFloat(countTo - counter) / CGFloat(countTo))
    }
}


struct CountdownPicker: View {
    
    @Binding var selectedTimeInterval: Int
    
    var body: some View {
        VStack {
            Picker("Minutes", selection: $selectedTimeInterval) {
                ForEach(0..<61) { minute in
                    Text("\(minute)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 100)
        }
    }
}


struct TimerControlView: View {
    
    @Binding var counter: Int
    @Binding var countTo: Int
    @Binding var timerRunning: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                timerRunning.toggle()
            }) {
                Image(systemName: timerRunning ? "pause" : "play")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("Color3"))
                    .padding()
            }
            
            Button(action: {
                counter = 0
                timerRunning = false
            }) {
                Image(systemName: "arrow.counterclockwise")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("Color3"))
                    .padding()
            }
        }
    }
}


struct VolumeSliderView: View {
    
    @Binding var audioPlayer: AVPlayer?
    @State private var volume: Float = 0.5
    
    var body: some View {
        VStack {
            Slider(value: $volume, in: 0...1)
                .frame(width: 250)
                .accentColor(Color("Color3"))
                .padding(.horizontal)
                .onChange(of: volume) { newValue in
                    audioPlayer?.volume = newValue
                }
        }
    }
}


struct FocusView: View {
    
    @Binding var counter: Int
    var countTo: Int
    
    var body: some View {
        ZStack {
            ProgressTrack()
            ProgressBar(counter: counter, countTo: countTo)
            Clock(counter: counter, countTo: countTo)
        }
    }
}


struct FocusSwiftUIView: View {
    
    @State var counter: Int = 0
    @State var countTo: Int = 30 * 60
    @State private var audioPlayer: AVPlayer?
    @State private var showingCountdownPicker = false
    @State private var selectedTimeInterval = 30
    @State private var timerRunning = false
    
    var body: some View {
        VStack {
            Spacer()
            FocusView(counter: $counter, countTo: countTo)
                .onTapGesture {
                    showingCountdownPicker = true
                }
            TimerControlView(counter: $counter, countTo: $countTo, timerRunning: $timerRunning)
                .padding(.bottom, 20)
            Spacer()
            BackgroundMusicView(audioPlayer: $audioPlayer)
            Spacer()
            VolumeSliderView(audioPlayer: $audioPlayer)
            Spacer()
        }
        .onReceive(timer, perform: handleTimer)
        .sheet(isPresented: $showingCountdownPicker, content: countdownPickerSheet)
    }
    
    
    func handleTimer(_ time: Date) {
        if timerRunning && (self.counter < self.countTo) {
            self.counter += 1
        }
    }
    
    
    func countdownPickerSheet() -> some View {
        VStack {
            Text("Select the countdown time")
                .font(.title2)
                .padding()
                
            CountdownPicker(selectedTimeInterval: $selectedTimeInterval)
                
            Button(action: {
                countTo = selectedTimeInterval * 60
                counter = 0
                showingCountdownPicker = false
            }) {
                Text("Set countdown time")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("Color3"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}


struct FocusSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        FocusSwiftUIView()
    }
}
