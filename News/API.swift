//
//  API.swift
//  News
//
//  Created by Henri Gil on 28/01/2018.
//  Copyright © 2018 Henri Gil. All rights reserved.
//

import Foundation
import Alamofire

class API {
    
    static let shared = API()
    
    private let manager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    func request(url: String, parameters: [String: Any], completion: @escaping ([Article]) -> () )  {
        
       var para = parameters
        para["apiKey"] = "c01696db7ffa4bef9312033d152906b3"
        
        var articles_array = [Article]()
        
        manager.request(url, method: HTTPMethod.get, parameters: para , encoding: URLEncoding.default , headers: nil).responseJSON { (response) in
            
            if let json = response.result.value {
                if  let JSON = json as? [String: Any] {
                    if let articles = JSON["articles"] as? [[String:Any]] {
                        for article in articles {
                            var source = Source(data: [:])
                            if let s = article["source"] as? [String:Any] {
                                source = Source(data: s)
                            }
                            
                            let article = Article(data: article, source: source)
                            articles_array.append(article)
                        }
                    }
                }
            }
            
            completion(articles_array)
        }
    }
    
}
