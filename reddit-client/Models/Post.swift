//
//  Post.swift
//  reddit-client
//
//  Created by Elina Semenko on 15.02.2022.
//

import Foundation

struct Data: Codable {
    let data: Children?
}

struct Children: Codable {
    let children: [PostData]?
    let after: String?
}

struct PostData: Codable {
    let data: Post?
}

struct Post: Codable {
    let title: String?
    let username: String?
    let domain: String?
    let created: Double?
    let image: Images?
    let comments: Int?
    let ups: Int?
    let downs: Int?
    let id: String?
    
    var rating: Int {
        return (ups ?? 0) + (downs ?? 0)
    }
    var timePassed: String {
        (Date().timeIntervalSince1970 - (created ?? 0)).redditTime
    }
    var imageLink: String? {
        image?.images?.first?.source?.url?.replacingOccurrences(of: "amp;", with: "")
    }
    var isSaved: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case title, username = "name", domain, ups, downs, created = "created_utc", comments = "num_comments", image = "preview", id
    }
}

struct Images: Codable {
    let images: [Image]?
    
    struct Image: Codable {
        let source: ImageSource?
        
        struct ImageSource: Codable {
            let url: String?
        }
    }
}
