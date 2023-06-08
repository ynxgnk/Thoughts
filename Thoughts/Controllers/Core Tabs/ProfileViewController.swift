//
//  ProfileViewController.swift
//  Thoughts
//
//  Created by Nazar Kopeyka on 14.04.2023.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate { /* 445 add UITableViewDelegate and dataSource */

    //Profile Photo
    
    //Full Name
    
    //Email
    
    //List of posts
    
    private var user: User? /* 508 */
    
    private let tableView: UITableView = { /* 438 */
        let tableView = UITableView() /* 439 */
        tableView.register(PostPreviewTableViewCell.self, /* 765 change UITableViewCell */
                           forCellReuseIdentifier: PostPreviewTableViewCell.identifier) /* 440 */ /* 766 change "cell" */
        return tableView /* 441 */
    }()
    
    let currentEmail: String /* 451 */
    
    init(currentEmail: String) { /* 452 */
        self.currentEmail = currentEmail /* 453 */
        super.init(nibName: nil, bundle: nil) /* 454 */
    }
    
    required init?(coder: NSCoder) { /* 455 */
        fatalError() /* 456 */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground /* 26 */
        setUpSignOutButton() /* 437 */
        setUpTable() /* 450 */
        title = "Profile" /* 466 */
        fetchPosts() /* 715 */
    }
    
    override func viewDidLayoutSubviews() { /* 446 */
        super.viewDidLayoutSubviews() /* 447 */
        tableView.frame = view.bounds /* 448 */
    }
    
    private func setUpTable() { /* 449 */
        view.addSubview(tableView) /* 442 */
        tableView.delegate = self /* 443 */
        tableView.dataSource = self /* 444 */
        setUpTableHeader() /* 482 */
        fetchProfileData() /* 484 */
    }
    
    private func setUpTableHeader(
        profilePhotoRef: String? = nil,
        name: String? = nil
    ) { /* 467 */ /* 485 add profilePhotoUrl, name */ /* 505 change to ...PhotoRef: String? */
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5)) /* 468 */
        headerView.backgroundColor = .systemBlue /* 469 */
        headerView.isUserInteractionEnabled = true /* 510 */
        headerView.clipsToBounds = true /* 470 */
        tableView.tableHeaderView = headerView /* 471 */
        
        //Profile picture
        let profilePhoto = UIImageView(image: UIImage(systemName: "person.circle")) /* 472 */
        profilePhoto.tintColor = .white /* 473 */
        profilePhoto.contentMode = .scaleAspectFit /* 474 */
        profilePhoto.frame = CGRect( /* 475 */
            x: (view.width-(view.width/4))/2,
            y: (headerView.height-(view.width/4))/2.5,
            width: view.width/4,
            height: view.width/4
        )
        profilePhoto.layer.masksToBounds = true /* 573 */
        profilePhoto.layer.cornerRadius = profilePhoto.width/2 /* 574 */
        profilePhoto.isUserInteractionEnabled = true /* 511 */
        headerView.addSubview(profilePhoto) /* 476 */
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePhoto)) /* 512 */
        profilePhoto.addGestureRecognizer(tap) /* 513 */
        
        //Email
        let emailLable = UILabel(frame: CGRect( /* 477 */
            x: 20,
            y: profilePhoto.bottom+10,
            width: view.width-40,
            height: 100))
        headerView.addSubview(emailLable) /* 478 */
        emailLable.text = currentEmail /* 479 */
        emailLable.textAlignment = .center /* 480 */
        emailLable.textColor = .white /* 509 */
        emailLable.font = .systemFont(ofSize: 25, weight: .bold) /* 481 */
        
        //Name
        if let name = name { /* 486 */
            title = name /* 487 */
        }
        
        if let ref = profilePhotoRef { /* 488 */
            //Fetch image
//            print("Found photo ref: \(ref)") /* 559 */
            StorageManager.shared.downloadUrlForProfilePicture(path: ref) { url in /* 564 will give a url back */
                guard let url = url else { /* 565 */
                    return /* 566 */
                }
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in /* 567 */
                    guard let data = data else { /* 568 */
                        return /* 569 */
                    }
                    DispatchQueue.main.async { /* 570 */
                        profilePhoto.image = UIImage(data: data) /* 571 */
                    }
                }
                
                task.resume() /* 572 */
            }
        }
    }
    
    @objc private func didTapProfilePhoto() { /* 514 */
        guard let myEmail = UserDefaults.standard.string(forKey: "email"),
              myEmail == currentEmail else { /* 527 */
            return /* 528 */
        }
        
        let picker = UIImagePickerController() /* 515 */
        picker.sourceType = .photoLibrary /* 516*/
        picker.delegate = self /* 517 */
        picker.allowsEditing = true /* 518 */
        present(picker, animated: true) /* 519 */
    }
    
    private func fetchProfileData() { /* 483 */
        DatabaseManager.shared.getUser(email: currentEmail) { [weak self] user in /* 500 */ /* 503 add weak self */
            guard let user = user else { /* 501 */
                return /* 502 */
            }
            self?.user = user /* 507 */
            
            DispatchQueue.main.async { /* 506 */
                self?.setUpTableHeader(
                    profilePhotoRef: user.profilePictureRef,
                    name: user.name
                ) /* 504 */
            }
        }
    }
    
    private func setUpSignOutButton() { /* 436 */
        navigationItem.rightBarButtonItem = UIBarButtonItem( /* 27 */
            title: "Sign Out",
            style: .done,
            target: self,
            action: #selector(didTapSignOut)
        )
    }
    
    /// Sign Out
    @objc private func didTapSignOut() { /* 28 */
        let sheet = UIAlertController(title: "Sign Out", message: "Are you sure you'd like to sing out?", preferredStyle: .actionSheet) /* 416 */
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) /* 417 */
        sheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in /* 418 */
            AuthManager.shared.signOut { [weak self] success in /* 407 */
                if success { /* 408 */
                    DispatchQueue.main.async { /* 409 */
                        UserDefaults.standard.set(nil, forKey: "email") /* 434 */
                        UserDefaults.standard.set(nil, forKey: "name") /* 435 */
                        UserDefaults.standard.set(false, forKey: "premium") /* 903 */
                        
                        let signInVC = SignInViewController() /* 410 */
                        signInVC.navigationItem.largeTitleDisplayMode = .always /* 411 */
                        
                        let navVC = UINavigationController(rootViewController: signInVC) /* 412 */
                        navVC.navigationBar.prefersLargeTitles = true /* 413 */
                        navVC.modalPresentationStyle = .fullScreen /* 415 */
                        self?.present(navVC, animated: true, completion: nil) /* 414 */
                    }
                }
            }
        }))
        present(sheet, animated: true) /* 419 */
    }
    
    //TableView
    
    private var posts: [BlogPost] = [] /* 575 */
    
    private func fetchPosts() { /* 576 */
        
        
        print("Fetching posts...") /* 716 */
        
        DatabaseManager.shared.getPosts(for: currentEmail) { [weak self] posts in /* 710 */
            self?.posts = posts /* 711 */
            print("Found \(posts.count) posts") /* 717 */
            DispatchQueue.main.async { /* 712 */
                self?.tableView.reloadData() /* 713 */
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { /* 458 */
        return posts.count /* 459 */ /* 577 change 10 */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { /* 457 */
        let post = posts[indexPath.row] /* 578 */
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as? PostPreviewTableViewCell else { /* 460 */ /* 767 add guard and change "cell" and as? */
            fatalError() /* 768 */
        }
        cell.configure(with: .init(title: post.title, imageUrl: post.headerImageUrl)) /* 769 to create a viewModel */
//        cell.textLabel?.text = post.title /* 461 */ /* 714 change "Blog post goes here" */
        return cell /* 462 */
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { /* 770 */
        return 100 /* 771 */
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { /* 579 */
        tableView.deselectRow(at: indexPath, animated: true) /* 580 */
        
        HapticsManager.shared.vibrateForSelection() /* 930 */
        
        var isOwnedByCurrentUser = false /* 885 */
        if let email = UserDefaults.standard.string(forKey: "email") { /* 886 */
            isOwnedByCurrentUser = email == currentEmail /* 887 */
        }
        
        if !isOwnedByCurrentUser { /* 890 */
            if IAPManager.shared.canViewPost { /* 892 */
                let vc = PostViewController(
                    post: posts[indexPath.row],
                    isOwnedByCurrentUser: isOwnedByCurrentUser
                ) /* 893 copy from 581 and paste */
                vc.navigationItem.largeTitleDisplayMode = .never /* 893 */
                vc.title = "Post" /* 893 */
                navigationController?.pushViewController(vc, animated: true) /* 893 */
            }
            else { /* 894 */
                let vc = PayWallViewController() /* 895 */
                present(vc, animated: true) /* 896 */
            }
        }
        else { /* 891 */
            // Our post
            let vc = PostViewController(
                post: posts[indexPath.row],
                isOwnedByCurrentUser: isOwnedByCurrentUser
            ) /* 581 */ /* 829 add post */ /* 884 add isOwned */
    //        vc.title = posts[indexPath.row].title /* 582 */
            vc.navigationItem.largeTitleDisplayMode = .never /* 831 */
            vc.title = "Post" /* 830 */
            navigationController?.pushViewController(vc, animated: true) /* 583 */
        }
    }
        
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationBarDelegate { /* 520 */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { /* 521 */
        picker.dismiss(animated: true, completion: nil) /* 522 */
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { /* 523 */
        picker.dismiss(animated: true, completion: nil) /* 529 */
        guard let image = info[.editedImage] as? UIImage else { /* 524 */
            return /* 525 */
        }
        
        StorageManager.shared.uploadUserProfilePicture( /* 526 */
            email: currentEmail,
            image: image
        ) { [weak self] success in /* 542 add weak self */
            guard let strongSelf = self else { return } /* 543 */
            if success {
                //Update database
                DatabaseManager.shared.updateProfilePhoto(email: strongSelf.currentEmail) { updated in /* 541 */
                    guard updated else { /* 557 */
                        return /* 558 */
                    }
                    DispatchQueue.main.async { /* 555 */
                        strongSelf.fetchProfileData() /* 556 */
                    }
                }
            }
        }
    }
}
