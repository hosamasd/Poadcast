//
//  PodcastModel.swift
//  Poadcast
//
//  Created by hosam on 4/30/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

struct PodcastModel: Codable {
   
     var artistName:String?
    var trackName:String?
}

struct Result: Codable {
     let resultCount: Int
    let results:[PodcastModel] 
    
    
   
}
