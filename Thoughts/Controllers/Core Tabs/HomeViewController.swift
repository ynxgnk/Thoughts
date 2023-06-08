//
//  ViewController.swift
//  Thoughts
//
//  Created by Nazar Kopeyka on 14.04.2023.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource { /* 838 add 2 protocols */

    private let composeButton: UIButton = { /* 584 */
        let button = UIButton() /* 585 */
        button.backgroundColor = .systemBlue /* 586 */
        button.tintColor = .white /* 587 */
        button.setImage(UIImage(systemName: "square.and.pencil",
                        withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)),
                        for: .normal) /* 588 */
        button.layer.cornerRadius = 30 /* 589 */
        button.layer.shadowColor = UIColor.label.cgColor /* 590 */
        button.layer.shadowOpacity = 0.4 /* 591 */
        button.layer.shadowRadius = 10 /* 592 */
        return button /* 593 */
    }()
    
    private let tableView: UITableView = { /* 833 copy from 438 and paste */
        let tableView = UITableView() /* 833 */
        tableView.register(PostPreviewTableViewCell.self, /* 833 */
                           forCellReuseIdentifier: PostPreviewTableViewCell.identifier) /* 833 */
        return tableView /* 833 */
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground /* 1 */
        view.addSubview(tableView) /* 834 */ /* */
        view.addSubview(composeButton) /* 594 */
        composeButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside) /* 596 */
        tableView.delegate = self /* 836 */
        tableView.dataSource = self /* 837 */
        fetchAllPosts() /* 840 */
    }

    override func viewDidLayoutSubviews() { /* 595 */
        super.viewDidLayoutSubviews() /* 595 */
        composeButton.frame = CGRect(x: view.frame.width - 88,
                               y: view.frame.height - 88 - view.safeAreaInsets.bottom,
                               width: 60,
                               height: 60
        ) /* 595 */
        tableView.frame = view.bounds /* 835 */
    }
    
    @objc private func didTapCreate() { /* 597 */
        let vc = CreateNewPostViewController() /* 598 */
        vc.title = "Create Post" /* 599 */
        let navVC = UINavigationController(rootViewController: vc) /* 600 */
        present(navVC, animated: true) /* 601 */
    }
    
    private var posts: [BlogPost] = [] /* 839 copy from ProfileViewController and paste */
    
    private func fetchAllPosts() { /* 839 */
        print("Fetching home feed...") /* 839 */
        
        DatabaseManager.shared.getAllPosts { [weak self] posts in /* 841 */
            self?.posts = posts /* 842 */
            DispatchQueue.main.async {/* 843 */
                self?.tableView.reloadData() /* 844 */
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { /* 839 */
        return posts.count /* 839 */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { /* 839 */
        let post = posts[indexPath.row] /* 839 */
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as? PostPreviewTableViewCell else { /* 839 */
            fatalError() /* 839 */
        }
        cell.configure(with: .init(title: post.title, imageUrl: post.headerImageUrl)) /* 839 */
        return cell /* 839 */
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { /* 839 */
        return 100 /* 839 */
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { /* 839 */
        tableView.deselectRow(at: indexPath, animated: true) /* 839 */
        
        HapticsManager.shared.vibrateForSelection() /* 929 */
        
        guard IAPManager.shared.canViewPost else { /* 897 */
            let vc = PayWallViewController() /* 898 */
            present(vc, animated: true, completion: nil) /* 899 */
            return /* 900 */
        }
                
        let vc = PostViewController(post: posts[indexPath.row]) /* 839 */
        vc.navigationItem.largeTitleDisplayMode = .never /* 839 */
        vc.title = "Post" /* 839 */
        navigationController?.pushViewController(vc, animated: true) /* 839 */
    }
}


