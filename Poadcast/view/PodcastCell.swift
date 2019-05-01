//
//  PodcastCell.swift
//  Poadcast
//
//  Created by hosam on 4/30/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

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
            print("url is " ,podcast.artworkUrl600 ?? "no url")
        }
    }
    
}
