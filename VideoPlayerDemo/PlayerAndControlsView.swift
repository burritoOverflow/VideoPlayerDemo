//
//  PlayerAndControlsView.swift
//  VideoPlayerDemo
//
//  Created by Standard on 7/12/21.
//

import SwiftUI
import AVFoundation

struct PlayerAndControlsView: View {
    private var player: AVPlayer
    @State private var videoLocation: Double = 0.0
    @State private var videoDuration: Double = 0.0
    @State private var isScrubbing: Bool = false
    
    init(url: URL) {
        self.player = AVPlayer(url: url)
    }
    
    var body: some View {
        VStack {
            WrappedPlayerView(videoLocation: $videoLocation, videoDuration: $videoDuration,
                              isScrubbing: $isScrubbing, player: self.player)
                .padding(2)
                .frame(width: 410, height: 300, alignment: .center)
            Spacer()
            ControlsView(videoLocation: $videoLocation, videoDuration: $videoDuration,
                         isScrubbing: $isScrubbing, player: self.player)
        }
    }
}

struct PlayerAndControlsView_Previews: PreviewProvider {
    static let url = URL(string: "fire")
    static var previews: some View {
        PlayerAndControlsView(url: url!).previewLayout(.sizeThatFits)
    }
}
