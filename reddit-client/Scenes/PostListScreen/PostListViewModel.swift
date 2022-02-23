//
//  PostListViewModel.swift
//  reddit-client
//
//  Created by Elina Semenko on 22.02.2022.
//

import Foundation

class PostListViewModel {
    var postList = [Post]()
    private(set) var subreddit: Subreddit = .ios
    private var currentAfter: String? = nil
    private var sorting: Sorting = .top
    private var limit = 15
    
    func loadPosts(completion: @escaping (Bool)->()) {
        let parameters: [Parameters: String]
        if let after = currentAfter {
            parameters = [.limit:String(describing: limit), .after: after]
        } else {
            parameters = [.limit:String(describing: limit)]
        }
            
        NetworkService.instance.performRequest(subreddit: subreddit, sorting: sorting, parameters: parameters) { [weak self] (result) in
            switch result {
            case let .success((aft,posts)):
                self?.currentAfter = aft
                self?.postList.append(contentsOf: posts)
                completion(true)
            case let .failure(error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
}
