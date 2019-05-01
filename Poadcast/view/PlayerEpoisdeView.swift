//
//  PlayerEpoisdeView.swift
//  Poadcast
//
//  Created by hosam on 5/1/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class PlayerEpoisdeView: UIView {
    
    var epoisde:EpoisdesModel! {
        didSet{
            guard let url = URL(string: epoisde.imageUrl ?? "") else { return  }
            epoisdeImageView.sd_setImage(with: url)
        epoisdeTitleLabel.text = epoisde.title
            epoisdeAuthorLabel.text = epoisde.author
        }
    }
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var epoisdeTitleLabel: UILabel!{
        didSet{
            epoisdeTitleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var epoisdeImageView: UIImageView!
    
    @IBOutlet weak var epoisdeAuthorLabel: UILabel!
    @IBAction func dimsiiTapped(_ sender: Any) {
        removeFromSuperview()
    }
    
    @IBOutlet weak var playTapped: UIButton!
}
