//
//  SingeltonAPI.swift
//  Poadcast
//
//  Created by hosam on 4/30/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import Alamofire
import FeedKit
class APIServices {
    
     let baseUrlItunes = "https://itunes.apple.com/search"
    static let shared = APIServices()
    
    func fetchEpoisdes(feedUrl:String,completion:  @escaping ([EpoisdesModel])->())  {
        
        
        
        guard let feedUrl =  URL(string: feedUrl) else { return  }
        //put it in background thread
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: feedUrl)
            parser.parseAsync { (result) in
                
                if let err = result.error {
                    print("an error happened ",err.localizedDescription)
                    return
                }
                guard let feed = result.rssFeed else {return}
                let epoisdes = feed.toEpoisdes()
                completion(epoisdes)
                
            }
        }
        
    }
    
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
