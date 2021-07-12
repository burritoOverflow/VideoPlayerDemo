//
//  ControlsView.swift
//  VideoPlayerDemo
//
//  Created by Standard on 7/12/21.
//

import SwiftUI
import AVFoundation

struct ControlsView: View {
    
    @Binding var videoLocation: Double
    @Binding var videoDuration: Double
    @Binding var isScrubbing: Bool
    let player: AVPlayer
    @State private var circleProgress: CGFloat = 1.0
    @State private var isPaused = true
    @State private var isLooped = true
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Rectangle().cornerRadius(20)
                        .frame(width: 60, height: 25)
                        .padding(.leading, 25)
                    
                    // show the video time
                    let videotime = self.removeTrailingZeroes(number:  self.videoLocation * self.videoDuration)
                    Text("\(videotime)")
                        .foregroundColor(.white)
                        .bold()
                        .padding(.leading, 25)
                }
                
                // show the video percent circle
                VStack {
                    Circle()
                        .trim(from: 0.0001, to: CGFloat(Double(self.videoLocation)))
                        .stroke(Color.purple, style: StrokeStyle(lineWidth: 5, lineCap: CGLineCap.round))
                        .frame(height: 45)
                        .rotationEffect(.degrees(-90))
                        .overlay(Text("\(self.removeTrailingZeroes(number: self.videoLocation * 100.0))%").bold())
                        .font(.caption)
                        .foregroundColor(.black)
                }
                
                ZStack {
                    Rectangle()
                        .cornerRadius(20)
                        .frame(width: 60, height: 25)
                        .padding(.trailing, 25)
                    let currentVideoProgress = self.removeTrailingZeroes(number: self.videoDuration)
                    Text("\(currentVideoProgress)")
                        .foregroundColor(.white)
                        .bold()
                        .padding(.trailing, 25)
                }
            }
            
            Slider(value: $videoLocation, in: 0...1, onEditingChanged: sliderChanged)
                .accentColor(Color.purple)
                .padding(.horizontal, 2)
                .background(Color.black)
                .cornerRadius(50)
                .shadow(color: .white, radius: 5, x: 0, y: 0)
                .padding(EdgeInsets(top: 0, leading: 30, bottom: 10, trailing: 30))
            
            HStack {
                Spacer()
                // pause/play button
                Button(action: togglePlayPause) {
                    Image(systemName: self.isPaused ? "play" : "pause")
                        .padding(.horizontal)
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.green)
                        .cornerRadius(50)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 10))
                }
                
                // stop button
                Button(action: stop) {
                    Image(systemName: "stop")
                        .padding(.horizontal)
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.red)
                        .cornerRadius(50)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 10))
                }
                
                Button(action: {
                    self.toggleIsLooped()
                    self.loop()
                }) {
                    Image(systemName: self.isLooped ? "repeat" : "checkmark.circle")
                }
                .padding(.horizontal)
                .padding(6)
                .foregroundColor(Color.white)
                .background(Color.purple)
                .cornerRadius(50)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 50))
            }
        }
    }
    
    func sliderChanged(scrubbing: Bool) {
        // if scrubbing avoid updating the timer with the periodic observer
        if scrubbing {
            self.isScrubbing = true
            self.pausePlayer(true)
        }
        
        if !self.isScrubbing {
            let targetTime = CMTime(seconds: self.videoLocation * self.videoDuration, preferredTimescale: 600)
            
            self.player.seek(to: targetTime) { _ in
                // done seeking
                self.isScrubbing = false
                self.pausePlayer(false)
            }
            
        }
    }
    
    func togglePlayPause() {
        self.pausePlayer(!self.isPaused)
    }
    
    func pausePlayer(_ pause: Bool) {
        self.isPaused = pause
        self.isPaused ? self.player.pause() : self.player.play()
    }
    
    func stop() {
        self.togglePlayPause()
        self.player.pause()
        self.player.seek(to: CMTime(seconds: 0.0, preferredTimescale: 600))
    }
    
    func loop() {
        NotificationCenter.default.removeObserver(self.player.currentItem!)
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { _ in
            self.player.seek(to: .zero)
            self.player.play()
        }
    }
    
    func toggleIsLooped() {
        self.isLooped.toggle()
    }
    
    func removeTrailingZeroes(number: Double) -> String {
        // remove all decimal places
        let convertedNumber = String(format: "%.0f", number)
        if convertedNumber == "nan" {
            return "0"
        } else {
            return convertedNumber
        }
    }
    
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView(videoLocation: .constant(0.0), videoDuration: .constant(0.0), isScrubbing: .constant(true), player: AVPlayer()).previewLayout(.sizeThatFits)
    }
}
