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
    
    init(feed:RSSFeedItem) {
        self.title = feed.title ?? "no title"
        self.pubDate = feed.pubDate ?? Date()
        self.description = feed.description ?? "no description"
    }
}

