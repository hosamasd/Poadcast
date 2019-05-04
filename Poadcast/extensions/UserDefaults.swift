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
    static let downloadEpoisdeKey = "downloadEpoisdeKey"
    func savePodcasts() -> [PodcastModel] {
        guard let keys = UserDefaults.standard.data(forKey: UserDefaults.ketTrack) else {return []}
        guard let podcasts = NSKeyedUnarchiver.unarchiveObject(with: keys) as? [PodcastModel] else {return []}
        
        return podcasts
    }
    
    func downloadEpoisde(epoisde: EpoisdesModel)  {
        var dowloadedEpoisdes = downloadedEpoisde()
        dowloadedEpoisdes.append(epoisde)
        do {
          let data =   try JSONEncoder().encode(dowloadedEpoisdes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadEpoisdeKey)
        } catch let err {
            print("failed to encode ",err.localizedDescription)
        }
      }
    
    func downloadedEpoisde() -> [EpoisdesModel] {
        guard let data = data(forKey: UserDefaults.downloadEpoisdeKey) else { return [] }
        
        do {
          let epoisde =   try JSONDecoder().decode([EpoisdesModel].self, from: data)
            return epoisde
        } catch let err {
            print("can not reterive data ",err.localizedDescription)
        }
        return []
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
