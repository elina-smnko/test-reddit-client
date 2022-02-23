//
//  PostListViewController.swift
//  reddit-client
//
//  Created by Elina Semenko on 22.02.2022.
//

import UIKit

class PostListViewController: UIViewController {
    private var viewModel: PostListViewModel = PostListViewModel()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        updateTable()
        setupNavigationBar()
        
    }
    
    private func setupNavigationBar() {
        navigationItem.title = viewModel.subreddit.rawValue
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: nil)
    }
    
    private func updateTable() {
        viewModel.loadPosts { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "PostScreenViewController") as? PostScreenViewController else { return }
        let viewModel = PostScreenViewModel(post: self.viewModel.postList[indexPath.row])
        controller.viewModel = viewModel
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.postList.count - 2 {
            viewModel.loadPosts { [weak self] (success) in
                if success {
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension PostListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        cell.configure(viewModel.postList[indexPath.row])
        return cell
    }
}
