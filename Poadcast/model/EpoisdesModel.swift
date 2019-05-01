//
//  EpoisdesModel.swift
//  Poadcast
//
//  Created by hosam on 5/1/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import FeedKit
struct EpoisdesModel {
    
    let title:String
    let pubDate:Date
    let description:String
    var imageUrl:String?
    let author :String
    
    
    init(feed:RSSFeedItem) {
        self.title = feed.title ?? "no title"
        self.pubDate = feed.pubDate ?? Date()
        self.description = feed.iTunes?.iTunesSubtitle ?? feed.description ?? "no description"
        self.imageUrl = feed.iTunes?.iTunesImage?.attributes?.href
        self.author = feed.author ?? ""
    }
}

