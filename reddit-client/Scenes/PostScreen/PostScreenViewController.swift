//
//  PostScreenViewController.swift
//  reddit-client
//
//  Created by Elina Semenko on 15.02.2022.
//

import UIKit

class PostScreenViewController: UIViewController {
    var viewModel: PostScreenViewModel?
    @IBOutlet weak private var postView: PostView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let post = viewModel?.post else { return }
        postView.show(post: post)
    }
}

