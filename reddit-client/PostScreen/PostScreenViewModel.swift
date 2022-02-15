//
//  PostScreenViewModel.swift
//  reddit-client
//
//  Created by Elina Semenko on 15.02.2022.
//

import Foundation

class PostScreenViewModel {
    
    func fetchPosts(completion: @escaping (Post?) -> ()) {
        NetworkService.instance.performBaseRequest { result in
            switch result {
            case let .success(posts):
                print(posts)
                completion(posts.first)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
