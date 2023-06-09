//
//  BackgroundMusic.swift
//  selflogue
//
//  Created by Chew Jun Pin on 30/4/2023.
//

import AVFoundation
import SwiftUI


/// `BackgroundMusicView` is a SwiftUI view that displays buttons for background music playback during the focus timer session.
/// It allows the user to select different background music options to play while focusing.
///
/// `BackgroundMusicView` follows the MVVM (Model-View-ViewModel) architecture.
/// It acts as the View, responsible for rendering the user interface and handling user interactions.
///
/// The view consists of circular buttons representing different background music options.
/// It utilizes the AVFoundation framework to handle audio playback and AVPlayer for managing the audio player instance.
///
/// `BackgroundMusicView` communicates with the AVPlayer instance through a binding (`audioPlayer`).
/// It handles the setup and play/pause functionality for the selected background music.
/// 
/// For the OOP part, `BackgroundMusicView` utilizes polymorphism by dynamically rendering circular buttons based on the provided symbols, allowing for extensibility and flexibility in adding more background music options.
///
/// The audio playback logic and UI rendering are encapsulated within `BackgroundMusicView`, providing a clean interface for interacting with background music options.



struct BackgroundMusicView: View {
    
    
    let symbols = ["keyboard", "wave.3.right", "cloud.rain", "music.note"]
    @Binding var audioPlayer: AVPlayer?
    
    
    var body: some View {
        
        HStack(spacing: 20) {
            ForEach(symbols.indices, id: \.self) { index in
                circularButton(forIndex: index)}
        }.onAppear(perform: setupAudioPlayerObserver)
         .onDisappear(perform: removeAudioPlayerObserver)
        
    }

    
    // Customize the music buttons
    private func circularButton(forIndex index: Int) -> some View {
        
        Button(action: {
            playAudio(forIndex: index)
        }){
            ZStack{
                Circle()
                    .fill(Color("Color3"))
                    .opacity(0.9) // Adjust the opacity as desired
                    .frame(width: 50, height: 50)
                
                Image(systemName: symbols[index])
                    .foregroundColor(.white)
                    .font(.system(size: 20))
            }
        }
        
    }

    
    
    private func setupAudioPlayerObserver() {
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { _ in
            if let audioPlayer = audioPlayer {
                audioPlayer.seek(to: .zero)
                audioPlayer.play()
            }
        }
        
    }

    
    private func removeAudioPlayerObserver() {
        
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
    }

    
    private func playAudio(forIndex index: Int) {
        
        guard let url = Bundle.main.url(forResource: audioFileName(forIndex: index), withExtension: "mp3") else {
            print("Audio file not found")
            return
        }

        if let currentItemURL = (audioPlayer?.currentItem?.asset as? AVURLAsset)?.url, currentItemURL == url {
            toggleAudioPlayback()
        } else {
            setupAndPlayAudio(url: url)
        }
        
    }

    
    private func setupAndPlayAudio(url: URL) {
        
        audioPlayer = AVPlayer(url: url)
        audioPlayer?.actionAtItemEnd = .none
        audioPlayer?.play()
        
    }

    
    private func toggleAudioPlayback() {
        
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.rate == 0 ? audioPlayer.play() : audioPlayer.pause()
        
    }

    
    private func audioFileName(forIndex index: Int) -> String {
        
        switch index {
            case 0: return "keyboard"
            case 1: return "river"
            case 2: return "rain"
            case 3: return "lofi"
            default: return ""
        }
        
    }

}
