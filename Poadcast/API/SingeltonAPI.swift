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
    
    func downloadEpoisde(epoisde: EpoisdesModel)  {
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        
        Alamofire.download(epoisde.streamUrl, to: downloadRequest).downloadProgress { (progress) in
            print(progress.fractionCompleted)
            }.response { (res) in
                guard let fileUrl =  res.destinationURL?.absoluteString else {return}
                
                var downloadeEpoisde = UserDefaults.standard.downloadedEpoisde()
                guard let index = downloadeEpoisde.index(where: {
                    $0.author == epoisde.author &&
                    $0.title == epoisde.title
                }) else {return}
                
                downloadeEpoisde[index].fileUrl = fileUrl
                do{
                    let data = try JSONEncoder().encode(downloadeEpoisde)
                    UserDefaults.standard.set(data, forKey: UserDefaults.downloadEpoisdeKey)
                    
                }catch let err {
                    print("can not encode with file url ",err)
                }
        }
    }
    
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
