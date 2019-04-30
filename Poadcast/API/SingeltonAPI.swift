//
//  SingeltonAPI.swift
//  Poadcast
//
//  Created by hosam on 4/30/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import Alamofire

class APIServices {
    
     let baseUrlItunes = "https://itunes.apple.com/search"
    static let shared = APIServices()
    
    func getPodcast(text:String,completion: @escaping (PodcastModel)->())  {
       
        let params = ["term":text,"media":"podcast"]
        
        Alamofire.request(baseUrlItunes, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if let err = response.error {
                print(err)
                return
            }
            guard let data = response.data else {return}
            do{
                let welcome = try JSONDecoder().decode(Result.self, from: data)
                
                welcome.results.forEach({ (pod) in
                    completion(pod)
                })
                
                
            }catch let err {
                print(err.localizedDescription)
            }
        }
    }
}
