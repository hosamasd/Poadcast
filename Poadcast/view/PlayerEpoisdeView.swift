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
            miniEpoisdeImageView.sd_setImage(with: url)
            playEpoisde()
        epoisdeTitleLabel.text = epoisde.title
            miniEpoisdeTitle.text = epoisde.title
            epoisdeAuthorLabel.text = epoisde.author
        }
    }
   
    @IBOutlet weak var miniEpoisdeTitle: UILabel!
    @IBOutlet weak var miniEpoisdeImageView: UIImageView!
    @IBOutlet weak var maxStackView: UIStackView!
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var epoisdeSliderValue: UISlider!
    @IBOutlet weak var currentDurationLabel: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    @IBOutlet weak var epoisdeImageView: UIImageView!{
        didSet{
            epoisdeImageView.layer.cornerRadius = 6
            epoisdeImageView.clipsToBounds = true
            epoisdeImageView.transform = fixedShrinkVale
        }
    }
    @IBOutlet weak var playPauseButton: UIButton!{
        didSet{
            playPauseButton.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(handlPlaying), for: .touchUpInside)
           
        }
    }
    @IBOutlet weak var epoisdeTitleLabel: UILabel!{
        didSet{
            epoisdeTitleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var miniEpoisdeForwardButton: UIButton!{
        didSet{
            miniEpoisdeForwardButton.addTarget(self, action: #selector(fastSpeedTapped(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var miniEpoisdePauseButton: UIButton!{
        didSet{
            miniEpoisdePauseButton.addTarget(self, action: #selector(handlPlaying), for: .touchUpInside)
            
        }
    }
    
    @IBOutlet weak var epoisdeAuthorLabel: UILabel!
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMaximizeView)))
        // [weak self ] for removing retain cycle of theses clousres
        
        observeCurrentPlayerTime()
        
        let time = CMTimeMake(value: 1, timescale: 3)
       let times =  [NSValue(time: time)]
        avPlayer.addBoundaryTimeObserver(forTimes: times, queue: .main) {[weak self ] in
            self?.enLargeImageView()
        }
    }
    
    static func initFromNib() -> PlayerEpoisdeView {
        return Bundle.main.loadNibNamed("PlayerEpoisdeView", owner: self, options: nil)?.first as! PlayerEpoisdeView
    }
    deinit {
       print("PlayerEpoisdeView reclaimed from memory")
    }
    
    @IBAction func fastSpeedTapped(_ sender: Any) {
        //minus fifteen seconds to slider
       seekToCurrentTimes(delta: 15)
    }
   
    
    @IBAction func reWindSpeedTapped(_ sender: Any) {
        seekToCurrentTimes(delta: -15)
    }
    @IBAction func sliderChangeValue(_ sender: UISlider) {
        let percentage = sender.value
        
        guard let totalSec = avPlayer.currentItem?.duration else { return  }
        let durationInSeconds = CMTimeGetSeconds(totalSec)
        
        let seekInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekInSeconds, preferredTimescale: 1)
        
        avPlayer.seek(to: seekTime)
        
    }
    @IBAction func dimsiiTapped(_ sender: Any) {
//                     removeFromSuperview()
        let mainTab = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarVC
        mainTab?.handleMinimizePlayerView()
        
       
    }
    
    @IBAction func sliderChangeSounds(_ sender: UISlider) {
        avPlayer.volume = sender.value
    }
    
    
    fileprivate func seekToCurrentTimes(delta: Int64) {
        //add fifteen seconds to slider
        let fifteenSecond = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(avPlayer.currentTime(), fifteenSecond)
        
        avPlayer.seek(to: seekTime)
    }
    
    fileprivate func observeCurrentPlayerTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        avPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self ] (time) in
            self?.currentDurationLabel.text = time.toStringDisplay()
            guard  let duration =   self?.avPlayer.currentItem?.duration.toStringDisplay() else{return}
            self?.totalDurationLabel.text = duration
            self?.updateCurrentSlider()
        }
    }
    
    func updateCurrentSlider()  {
        let currentSec = CMTimeGetSeconds(avPlayer.currentTime())
        let total = CMTimeGetSeconds(avPlayer.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        
    self.epoisdeSliderValue.value = Float(currentSec / total)
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
            
            playPauseButton.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
             miniEpoisdePauseButton.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
            enLargeImageView()
        }else {
            avPlayer.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play-button-1"), for: .normal)
             miniEpoisdePauseButton.setImage(#imageLiteral(resourceName: "play-button-1"), for: .normal)
            shrinkImageView()
        }
    }
    
    @objc func handleMaximizeView(){
        let mainTab = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarVC
        mainTab?.handleMaximizePlayerView(epoisde: nil)
    }
}
