//
//  ViewController.swift
//  WXYC TV
//
//  Created by Jake Bromberg on 12/2/17.
//  Copyright © 2017 wxyc.org. All rights reserved.
//

import UIKit

class TVViewController: UIViewController, NowPlayingPresentable, PlaylistServiceObserver {
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songLabel: SpringLabel!
    
    let playlistService = PlaylistService()
    let radioPlayer = RadioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.albumImageView.layer.cornerRadius = 6.0
        self.albumImageView.layer.masksToBounds = true
        
        self.playlistService.add(self)
        self.radioPlayer.play()
    }

    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            switch press.type {
            case .playPause:
                self.radioPlayer.isPlaying ? self.radioPlayer.pause() : self.radioPlayer.play()
            default:
                break
            }
        }
    }
    
    func playPressed() {
        radioPlayer.play()
    }
    
    func pausePressed() {
        radioPlayer.pause()
    }
}

