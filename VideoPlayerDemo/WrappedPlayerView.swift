//
//  WrappedPlayerView.swift
//  VideoPlayerDemo
//
//  Created by Standard on 7/12/21.
//

import Foundation
import SwiftUI
import AVFoundation

struct WrappedPlayerView: UIViewRepresentable {
    
    @Binding var videoLocation: Double
    @Binding var videoDuration: Double
    @Binding var isScrubbing: Bool
    let player: AVPlayer
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<WrappedPlayerView>) {
        //
    }
    
    func makeUIView(context: UIViewRepresentableContext<WrappedPlayerView>) -> UIView {
        let newUIView = PlayerUIView(player: player, videoLocation: $videoLocation, videoDuration: $videoDuration, isScrubbing: $isScrubbing)
        return newUIView
    }
}
