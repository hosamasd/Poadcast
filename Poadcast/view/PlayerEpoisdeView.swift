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
    let fixedShrinkVale = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    var epoisde:EpoisdesModel! {
        didSet{
            guard let url = URL(string: epoisde.imageUrl ?? "") else { return  }
            epoisdeImageView.sd_setImage(with: url)
            playEpoisde()
        epoisdeTitleLabel.text = epoisde.title
            epoisdeAuthorLabel.text = epoisde.author
        }
    }
    @IBOutlet weak var epoisdeImageView: UIImageView!{
        didSet{
            epoisdeImageView.transform = fixedShrinkVale
        }
    }
    @IBOutlet weak var playPauseButton: UIButton!{
        didSet{
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(handlPlaying), for: .touchUpInside)
           
        }
    }
    @IBOutlet weak var epoisdeTitleLabel: UILabel!{
        didSet{
            epoisdeTitleLabel.numberOfLines = 2
        }
    }
   
    
    @IBOutlet weak var epoisdeAuthorLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let time = CMTimeMake(value: 1, timescale: 3)
       let times =  [NSValue(time: time)]
        avPlayer.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            self.enLargeImageView()
        }
    }
    
    @IBAction func dimsiiTapped(_ sender: Any) {
                     removeFromSuperview()
       
    }
    
    
    
    func playEpoisde()  {
        guard let url = URL(string: epoisde.streamUrl ) else { return }
        let playerItem = AVPlayerItem(url: url)
        
        avPlayer.replaceCurrentItem(with: playerItem)
        avPlayer.play()
    }
    
    fileprivate func enLargeImageView() {
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.epoisdeImageView.transform = .identity
        }, completion: nil)
    }
    
    fileprivate func shrinkImageView() {
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.epoisdeImageView.transform = self.fixedShrinkVale
        }, completion: nil)
    }
    
    @objc func handlPlaying(sender: UIButton)  {
        if avPlayer.timeControlStatus == .paused  {
            avPlayer.play()
            
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enLargeImageView()
        }else {
            avPlayer.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            shrinkImageView()
        }
    }
}
