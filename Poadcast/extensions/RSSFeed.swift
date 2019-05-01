//
//  RSSFeed.swift
//  Poadcast
//
//  Created by hosam on 5/1/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import FeedKit

extension RSSFeed {
    
    func toEpoisdes() -> [EpoisdesModel] {
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        
        var epoisdes = [EpoisdesModel]()
        items?.forEach({ (feedItem) in
            
            var epoisde = EpoisdesModel(feed: feedItem)
            if epoisde.imageUrl == nil {
                epoisde.imageUrl = imageUrl
            }
            epoisdes.append(epoisde)
        })
        return epoisdes
    }
}
