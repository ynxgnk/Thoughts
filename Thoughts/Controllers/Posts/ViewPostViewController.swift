//
//  PostViewController.swift
//  Thoughts
//
//  Created by Nazar Kopeyka on 14.04.2023.
//

import UIKit

class PostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate { /* 794 add 2 protocols */

    private let post: BlogPost /* 775 */
    private let isOwnedByCurrentUser: Bool /* 883 */
    
    init(post: BlogPost, isOwnedByCurrentUser: Bool = false) { /* 776 */ /* 881 add isOwned */
        self.post = post /* 777 */
        self.isOwnedByCurrentUser = isOwnedByCurrentUser /* 882 */
        super.init(nibName: nil, bundle: nil) /* 778 */
    }
    
    required init?(coder: NSCoder) { /* 779 */
        fatalError() /* 780 */
    }
    
    private let tableView: UITableView = { /* 781 */
       //title, header. body
        //poster
        let table = UITableView() /* 782 */
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell") /* 783 */
        table.register(PostHeaderTableViewCell.self,
                       forCellReuseIdentifier: PostHeaderTableViewCell.identifier) /* 785 */
        return table /* 784 */
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground /* 772 */
        view.addSubview(tableView) /* 795 */
        tableView.delegate = self /* 796 */
        tableView.dataSource = self /* 797 */
        
        if !isOwnedByCurrentUser { /* 888 */
            IAPManager.shared.logPostViewed() /* 889 */
        }
    }
    
    override func viewDidLayoutSubviews() { /* 773 */
        super.viewDidLayoutSubviews() /* 774 */
        tableView.frame = view.bounds /* 798 */
    }
    
    //Table
    
    func numberOfSections(in tableView: UITableView) -> Int { /* 799 */
        return 1 /* 800 */
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { /* 801 */
        return 3 // title, image, text /* 802 */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { /* 803 */
        let index = indexPath.row /* 804 */
        switch index { /* 805 */
        case 0: /* 806 */
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) /* 808 */
            cell.selectionStyle = .none /* 818 */
            cell.textLabel?.numberOfLines = 0 /* 828 */
            cell.textLabel?.font = .systemFont(ofSize: 25, weight: .bold) /* 832 */
            cell.textLabel?.text = post.title /* 809 */
            return cell /* 810 */
        case 1: /* 806 */
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostHeaderTableViewCell.identifier,
                                                           for: indexPath) as? PostHeaderTableViewCell else { /* 811 */
                fatalError() /* 817 */
            }
            cell.selectionStyle = .none /* 819 */
            cell.configure(with: .init(imageUrl: post.headerImageUrl)) /* 812 */
            return cell /* 813 */
        case 2: /* 806 */
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) /* 814 */
            cell.selectionStyle = .none /* 820 */
            cell.textLabel?.numberOfLines = 0 /* 827 */
            cell.textLabel?.text = post.text /* 815 */
            return cell /* 816 */
        default: /* 806 */
            fatalError() /* 807 */
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { /* 821 */
        let index = indexPath.row /* 822 copy from 803 and paste */
        switch index { /* 822 */
        case 0: /* 822 */
            return UITableView.automaticDimension /* 823 */
        case 1: /* 822 */
            return 150 /* 826 */
        case 2: /* 822 */
            return UITableView.automaticDimension /* 824 will automaticly size itself */
        default: /* 822 */
            return UITableView.automaticDimension /* 825 */
        }
    }
}
