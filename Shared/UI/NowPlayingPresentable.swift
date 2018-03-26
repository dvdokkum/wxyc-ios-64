//
//  NowPlayingPresentable.swift
//  WXYC
//
//  Created by Jake Bromberg on 12/2/17.
//  Copyright © 2017 wxyc.org. All rights reserved.
//

import UIKit
import Spring
import Core

public struct NowPlayingPresentation {
    let song: String
    let artist: String
    let albumImage: UIImage?
}

public protocol NowPlayingPresentable: class {
    var songLabel: SpringLabel! { get }
    var artistLabel: UILabel! { get }
    var albumImageView: UIImageView! { get }
}

public extension PlaylistServiceObserver where Self: UIResponder & NowPlayingPresentable {
    func updateWith(playcutResult: Result<Playcut>) {
        DispatchQueue.main.async {
            switch playcutResult {
            case .success(let playcut):
                self.songLabel.text = playcut.songTitle
                self.artistLabel.text = playcut.artistName
                
                self.userActivity = playcut.userActivityState()
                self.userActivity?.becomeCurrent()
            case .error(_):
                self.songLabel.text = RadioStation.WXYC.name
                self.artistLabel.text = RadioStation.WXYC.secondaryName
            }
        }
    }
    
    func updateWith(artworkResult: Result<UIImage>) {
        let artwork: UIImage
        
        switch artworkResult {
        case .success(let image):
            artwork = image
        case .error(_):
            artwork = #imageLiteral(resourceName: "logo")
        }
        
        DispatchQueue.main.async {
            UIView.transition(
                with: self.albumImageView,
                duration: 0.25,
                options: [.transitionCrossDissolve],
                animations: { self.albumImageView.image = artwork },
                completion: nil
            )
        }
    }
}
