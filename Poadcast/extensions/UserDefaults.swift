//
//  UserDefaults.swift
//  Poadcast
//
//  Created by hosam on 5/4/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import Foundation

extension UserDefaults {
    static let ketTrack = "ketTrack"
    func savePodcasts() -> [PodcastModel] {
        guard let keys = UserDefaults.standard.data(forKey: UserDefaults.ketTrack) else {return []}
        guard let podcasts = NSKeyedUnarchiver.unarchiveObject(with: keys) as? [PodcastModel] else {return []}
        
        return podcasts
    }
    
    func deletePodcast(pod: PodcastModel)  {
        let podcasts = savePodcasts()
        let filterPod = podcasts.filter { (p) -> Bool in
            return p.trackName != pod.trackName && p.artistName != pod.artistName
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: filterPod)
        UserDefaults.standard.set(data, forKey: UserDefaults.ketTrack)
        
    }
}
