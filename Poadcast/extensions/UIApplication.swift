//
//  UIApplication.swift
//  Poadcast
//
//  Created by hosam on 5/2/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static func getMainTabBarController() -> MainTabBarVC? {
    return shared.keyWindow?.rootViewController as? MainTabBarVC
    }
}
