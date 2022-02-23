//
//  PostTableViewCell.swift
//  reddit-client
//
//  Created by Elina Semenko on 22.02.2022.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postView: PostView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ post: Post) {
        postView.show(post: post)
    }

}
