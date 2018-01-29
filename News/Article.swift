//
//  Article.swift
//  News
//
//  Created by Henri Gil on 28/01/2018.
//  Copyright © 2018 Henri Gil. All rights reserved.
//

import Foundation

struct Source {
    var id: String?
    var name: String
    
    init(data: [String:Any]) {
        self.id = data["id"] as? String
        self.name = data["name"] as? String ?? ""
    }
}

struct Article {
    var source: Source?
    
    var author: String
    var title: String
    var description: String
    var url: String
    var urlToImage: String
    var publishedAt: String
    var dateForm: Date
    
    init(data: [String:Any], source: Source?) {
        self.source = source
        
        self.author = data["author"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        self.description = data["description"] as? String ?? ""
        self.url = data["url"] as? String ?? ""
        self.urlToImage = data["urlToImage"] as? String ?? ""

        self.publishedAt = data["publishedAt"] as? String ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yyyy"
        let date = dateFormatter.date(from: self.publishedAt)
        
        self.dateForm = date ?? Date()
        
        self.publishedAt = self.publishedAt.replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: "").replacingOccurrences(of: "-", with: "/")
        
    }
}

