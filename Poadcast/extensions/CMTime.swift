//
//  CMTime.swift
//  Poadcast
//
//  Created by hosam on 5/1/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import AVKit

extension CMTime {
    
    func toStringDisplay() ->String {
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let second = totalSeconds %  60
        let mintue = totalSeconds % (60 * 60) / 60
        let hours = totalSeconds / 60 / 60
        
        let displayString = String(format: "%02d:%02d:%02d", hours,mintue,second)
        
        return displayString
    }
}
