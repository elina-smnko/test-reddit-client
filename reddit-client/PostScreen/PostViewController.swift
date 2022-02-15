//
//  PostViewController.swift
//  reddit-client
//
//  Created by Elina Semenko on 15.02.2022.
//

import UIKit

class PostViewController: UIViewController {
    private var viewModel: PostScreenViewModel = PostScreenViewModel()
    @IBOutlet weak private var postView: PostView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchPosts { [weak self] post in
            guard let post = post else { return }
            DispatchQueue.main.async {
                self?.postView.show(post: post)
            }
        }
    }
}

