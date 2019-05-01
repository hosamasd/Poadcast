//
//  PodcastCell.swift
//  Poadcast
//
//  Created by hosam on 4/30/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var podcastImage: UIImageView!
    
    @IBOutlet weak var podcastLabelEpisode: UILabel!
    @IBOutlet weak var podcastLabelArtist: UILabel!
    @IBOutlet weak var podcastLabelTrack: UILabel!
    
    var podcast:PodcastModel! {
        didSet{
            podcastLabelTrack.text = podcast.trackName
            podcastLabelArtist.text = podcast.artistName
            podcastLabelEpisode.text = "\(podcast.trackCount ?? 0) epoiseds"
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else {return}
            
            podcastImage.sd_setImage(with: url, completed: nil)
        }
        
    }
    
}
