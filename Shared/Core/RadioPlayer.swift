//
//  RadioPlayer.swift
//  WXYC
//
//  Created by Jake Bromberg on 12/1/17.
//  Copyright © 2017 wxyc.org. All rights reserved.
//

import Foundation
import AVFoundation

internal final class RadioPlayer {
    public let streamURL: URL
    
    public init(streamURL: URL = URL.WXYCStream) {
        self.streamURL = streamURL
    }
    
    public var isPlaying: Bool {
        return player.isPlaying
    }
    
    public func play() {
        if self.isPlaying {
            return
        }
        
        try? AVAudioSession.sharedInstance().setActive(true)
        
        player.play()
    }
    
    public func pause() {
        player.pause()
        self.resetStream()
    }
    
    // MARK: Private
    
    private lazy var player: AVPlayer = AVPlayer(url: self.streamURL)
    
    private func resetStream() {
        let asset = AVAsset(url: self.streamURL)
        let playerItem = AVPlayerItem(asset: asset)
        player.replaceCurrentItem(with: playerItem)
    }
}

private extension AVPlayer {
    var isPlaying: Bool {
        return rate > 0.0
    }
}
