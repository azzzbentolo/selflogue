import SwiftUI
import AVFoundation
import CoreData


/// `FocusSwiftUIView` is a SwiftUI view that represents the focus timer screen.
/// It follows the MVVM (Model-View-ViewModel) architecture and utilizes the `FocusTimeManager` as the ViewModel.
///
/// The view is responsible for rendering the UI components, handling user interactions, and integrating with the `FocusTimeManager` to manage focus time sessions.
/// It displays the countdown timer, progress bar, control buttons, and allows the user to select the countdown time.
///
/// `FocusSwiftUIView` communicates with the `FocusTimeManager` to start/end focus sessions, track the progress, and retrieve focus time data.
/// It uses the `@State` and `@Binding` property wrappers to manage the state and enable two-way data binding with its child views.
///
/// By adhering to the MVVM architecture, `FocusSwiftUIView` separates the concerns of the view and the ViewModel, promoting better testability and maintainability of the codebase.
///
/// As for the OOP part, `FocusSwiftUIView` abstracts the underlying implementation details of the focus timer, exposing a clean interface for interacting with the timer and integrating with the `FocusTimeManager` for managing focus time data.


// Timer that emits a value every second.
let timer = Timer
    .publish(every: 1, on: .main, in: .common)
    .autoconnect()


// View that displays a clock representation of the remaining time.
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
    
    
    // Converts the counter value to minutes and seconds format.
    func counterToMinutes() -> String {
        let currentTime = countTo - counter
        let seconds = currentTime % 60
        let minutes = Int(currentTime / 60)
        return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
    }
}


// View that represents the track of the progress bar.
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


// View that represents the progress bar indicating the progress of the focus session.
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
    
    // Calculates the progress of the focus session as a value between 0 and 1.
    func progress() -> CGFloat {
        return (CGFloat(countTo - counter) / CGFloat(countTo))
    }
}


// View that allows selecting the countdown time in minutes.
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


// View that provides controls for starting, pausing, and resetting the focus session timer.
struct TimerControlView: View {
    
    @Binding var counter: Int
    @Binding var countTo: Int
    @Binding var timerRunning: Bool
    @Binding var focusPeriodStartDate: Date?
    var focusTimeManager: FocusTimeManager?
    var printTodayFocusTime: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                timerRunning.toggle()
                if timerRunning {
                    focusTimeManager?.startFocusSession()
                    focusPeriodStartDate = Date()
                } else {
                    if let startDate = focusPeriodStartDate {
                        let focusPeriodLength = Date().timeIntervalSince(startDate)
                        focusTimeManager?.incrementFocusTime(by: focusPeriodLength)
                        focusPeriodStartDate = nil
                    }
                }
                printTodayFocusTime()
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


// View that displays a volume slider to control the audio player's volume.
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


// View that represents the entire focus session view, including the progress track, progress bar, and clock.
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


// Main SwiftUI view representing the focus session screen.
struct FocusSwiftUIView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var focusTimeManager: FocusTimeManager? = nil
    @State private var focusPeriodStartDate: Date? = nil
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
            TimerControlView(
                counter: $counter,
                countTo: $countTo,
                timerRunning: $timerRunning,
                focusPeriodStartDate: $focusPeriodStartDate,
                focusTimeManager: focusTimeManager,
                printTodayFocusTime: printTodayFocusTime
            )
            .padding(.bottom, 20)


            Spacer()
            BackgroundMusicView(audioPlayer: $audioPlayer)
            Spacer()
            VolumeSliderView(audioPlayer: $audioPlayer)
            Spacer()
        }
        .onReceive(timer, perform: handleTimer)
        .sheet(isPresented: $showingCountdownPicker, content: countdownPickerSheet)
        .onAppear {
            self.focusTimeManager = FocusTimeManager(context: viewContext)
        }
    }
    
    
    // Handles the timer tick, incrementing the counter and updating focus time accordingly.
    func handleTimer(_ time: Date) {
        if timerRunning && (self.counter < self.countTo) {
            self.counter += 1
            if counter == countTo {
                if let startDate = focusPeriodStartDate {
                    let focusPeriodLength = Date().timeIntervalSince(startDate)
                    focusTimeManager?.incrementFocusTime(by: focusPeriodLength)
                    focusPeriodStartDate = nil
                }
            }
        }
    }

    
    // View presenting the countdown picker as a sheet.
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
    
    
    // Prints today's focus time. (For debugging)
    func printTodayFocusTime() {
        let focusTime = focusTimeManager?.getFocusTime(for: Date())
        print("Today's focus time: \(focusTime ?? 0) seconds")
    }
}

struct FocusSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        FocusSwiftUIView()
    }
}
