//
//  EpoisdeCell.swift
//  Poadcast
//
//  Created by hosam on 5/1/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class EpoisdeCell: UITableViewCell {

    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var epoisdeDescription: UILabel!
    @IBOutlet weak var epoisdeTitle: UILabel!{
        didSet{
            epoisdeTitle.numberOfLines = 2
        }
    }
    @IBOutlet weak var epoisdePubDate: UILabel!
    @IBOutlet weak var epoisdeImage: UIImageView!
   
    var epoisde:EpoisdesModel! {
        didSet{
             epoisdeTitle.text = epoisde.title
            epoisdeDescription.text =  epoisde.description
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
           let dateString = dateFormatter.string(from: epoisde.pubDate)
            
            epoisdePubDate.text = dateString
             let url =  URL(string: epoisde.imageUrl?.toSecrueHttps() ?? "")
           epoisdeImage.sd_setImage(with: url, completed: nil)
        }
    }
}
