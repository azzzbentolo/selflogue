//
//  BackgroundMusic.swift
//  selflogue
//
//  Created by Chew Jun Pin on 30/4/2023.
//

import AVFoundation
import SwiftUI


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
                    .fill(RadialGradient(gradient: Gradient(
                        colors: [Color("Color2"), Color("Color3")]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 20))
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
