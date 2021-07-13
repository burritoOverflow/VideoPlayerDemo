//
//  PlayerUIView.swift
//  VideoPlayerDemo
//
//  Created by Standard on 7/12/21.
//

import Foundation
import AVFoundation
import SwiftUI

class PlayerUIView: UIView, ObservableObject {
    
    let player: AVPlayer
    let playerLayer = AVPlayerLayer()
    private let videoLocation: Binding<Double>
    private let videoDuration: Binding<Double>
    private let isScrubbing: Binding<Bool>
    private var observeVideoDuration: NSKeyValueObservation?
    private var timeObservation: Any?

    init(player: AVPlayer, videoLocation: Binding<Double>, videoDuration: Binding<Double>, isScrubbing: Binding<Bool>) {
        self.player = player
        self.videoDuration = videoDuration
        self.videoLocation = videoLocation
        self.isScrubbing = isScrubbing
        
        super.init(frame: .zero)
        backgroundColor = .black
        playerLayer.player = player
        layer.addSublayer(playerLayer)
        
        observeVideoDuration = player.currentItem?.observe(\.duration, changeHandler: { [weak self] item, change in
            guard let value = self else { return }
            value.videoDuration.wrappedValue = item.duration.seconds
        })
        
        timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600), queue: nil) {
            [weak self] time in
            guard let value = self else { return }
            guard !value.isScrubbing.wrappedValue else { return }
            value.videoLocation.wrappedValue = time.seconds / value.videoDuration.wrappedValue
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Problem")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    func removeObservers() {
        self.observeVideoDuration?.invalidate()
        self.observeVideoDuration = nil
        
        if let observedTime = self.timeObservation {
            self.player.removeTimeObserver(observedTime)
            self.timeObservation = nil
        }
    }
    
    private func logState(caller: String) {
        print(caller, "Location: \(self.videoLocation.wrappedValue)", "Duration: \(self.videoDuration.wrappedValue)")
    }
    
}
