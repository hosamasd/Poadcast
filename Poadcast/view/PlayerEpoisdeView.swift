//
//  PlayerEpoisdeView.swift
//  Poadcast
//
//  Created by hosam on 5/1/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import AVKit
class PlayerEpoisdeView: UIView {
    let avPlayer: AVPlayer = {
       let av = AVPlayer()
        av.automaticallyWaitsToMinimizeStalling = false
        return av
    }()
    
    var epoisde:EpoisdesModel! {
        didSet{
            guard let url = URL(string: epoisde.imageUrl ?? "") else { return  }
            epoisdeImageView.sd_setImage(with: url)
            playEpoisde()
        epoisdeTitleLabel.text = epoisde.title
            epoisdeAuthorLabel.text = epoisde.author
        }
    }
     @IBOutlet weak var epoisdeImageView: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!{
        didSet{
            playPauseButton.addTarget(self, action: #selector(handlPlaying), for: .touchUpInside)
        }
    }
    @IBOutlet weak var epoisdeTitleLabel: UILabel!{
        didSet{
            epoisdeTitleLabel.numberOfLines = 2
        }
    }
   
    
    @IBOutlet weak var epoisdeAuthorLabel: UILabel!
    @IBAction func dimsiiTapped(_ sender: Any) {
        removeFromSuperview()
    }
    
    
    
    func playEpoisde()  {
        guard let url = URL(string: epoisde.streamUrl ) else { return }
        let playerItem = AVPlayerItem(url: url)
        
        avPlayer.replaceCurrentItem(with: playerItem)
        avPlayer.play()
    }
    
    @objc func handlPlaying(sender: UIButton)  {
        if avPlayer.timeControlStatus == .paused  {
            avPlayer.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }else {
            avPlayer.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
    }
}
