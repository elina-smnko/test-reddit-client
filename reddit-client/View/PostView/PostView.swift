//
//  PostView.swift
//  reddit-client
//
//  Created by Elina Semenko on 15.02.2022.
//

import UIKit
import SDWebImage

class PostView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var domainLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var commentsLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        let bundle = Bundle(for: PostView.self)
        bundle.loadNibNamed(String(describing: PostView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        layer.borderWidth = 1
        layer.borderColor = UIColor.purple.cgColor
    }
    
    func show(post: Post) {
        usernameLabel.text = post.username
        timeLabel.text = post.timePassed
        domainLabel.text = post.domain
        titleLabel.text = post.title
        ratingLabel.text = String(describing: post.rating)
        commentsLabel.text = String(describing: post.comments ?? 0)
        imageView.sd_setImage(with: URL(string: post.imageLink ?? ""), placeholderImage: UIImage(systemName: "camera.circle"))
        let image = post.isSaved ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        saveButton.setImage(image, for: .normal)
    }
}
