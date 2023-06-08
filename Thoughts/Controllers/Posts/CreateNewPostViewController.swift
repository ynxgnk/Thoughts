//
//  CreateNewPostViewController.swift
//  Thoughts
//
//  Created by Nazar Kopeyka on 14.04.2023.
//

import UIKit

class CreateNewPostViewController: UIViewController {

    //Title Field
    private let titleField: UITextField = { /* 617 */
        let field = UITextField() /* 618 */
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50)) /* 619 */
        field.leftViewMode = .always /* 620 */
        field.placeholder = "Enter Title..." /* 621 */
        field.autocapitalizationType = .words /* 622 */
        field.autocorrectionType = .no /* 623 */
        field.backgroundColor = .secondarySystemBackground /* 624 */
        field.layer.masksToBounds = true /* 625 */
        return field /* 626 */
    }()
    
    //Image header
    private let headerImageView: UIImageView = { /* 610 */
        let imageView = UIImageView() /* 611 */
        imageView.contentMode = .scaleAspectFill /* 612 */
        imageView.isUserInteractionEnabled = true /* 613 */
        imageView.clipsToBounds = true /* 692 */
        imageView.image = UIImage(systemName: "photo") /* 614 */
        imageView.backgroundColor = .tertiarySystemBackground /* 615 */
        return imageView /* 616 */
    }()
    
    //TextView for post
    private let textView: UITextView = { /* 627 */
        let textView = UITextView() /* 628 */
        textView.backgroundColor = .secondarySystemBackground /* 629 */
        textView.autocorrectionType = .no /* 645 */
        textView.isEditable = true /* 630 */
        textView.font = .systemFont(ofSize: 28) /* 631 */
        return textView /* 632 */
    }()
    
    private var selectedHeaderImage: UIImage? /* 641 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground /* 602 */
        view.addSubview(headerImageView) /* 633 */
        view.addSubview(textView) /* 634 */
        view.addSubview(titleField) /* 635 */
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapHeader)) /* 646 */
        headerImageView.addGestureRecognizer(tap) /* 647 */
        configureButtons() /* 609 */
    }
    
    override func viewDidLayoutSubviews() { /* 636 */
        super.viewDidLayoutSubviews() /* 637 */
        
        titleField.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.width-20, height: 50) /* 638 */
        headerImageView.frame = CGRect(x: 0, y: titleField.bottom+5, width: view.width, height: 160) /* 639 */
        textView.frame = CGRect(x: 10, y: headerImageView.bottom+10, width: view.width-20, height: view.height-210-view.safeAreaInsets.top) /* 640 */
    }
    
    @objc private func didTapHeader() { /* 648 */
        let picker = UIImagePickerController() /* 649 */
        picker.sourceType = .photoLibrary /* 650 */
        picker.delegate = self /* 651 */
        present(picker, animated: true) /* 652 */
    }
    
    private func configureButtons() { /* 608 */
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .done,
            target: self,
            action: #selector(didTapCancel) /* 603 */
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Post",
            style: .done,
            target: self,
            action: #selector(didTapPost) /* 604 */
        )
    }
    
    @objc private func didTapCancel() { /* 605 */
        dismiss(animated: true, completion: nil) /* 607 */
    }
    
    @objc private func didTapPost() { /* 606 */
        //Check data and post
        guard let title = titleField.text,
              let body = textView.text,
              let headerImage = selectedHeaderImage,
              let email = UserDefaults.standard.string(forKey: "email"), /* 672 */
        !title.trimmingCharacters(in: .whitespaces).isEmpty,
        !body.trimmingCharacters(in: .whitespaces).isEmpty else { /* 642 */
            
            let alert = UIAlertController(title: "Enter Post Details",
                                          message: "Please enter a title, body, and select a image to continue.",
                                          preferredStyle: .alert) /* 689 */
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)) /* 690 */
            present(alert, animated: true) /* 691 */
            return /* 643 */
        }
        
        print("Starting post...") /* 693 */
        
        let newPostId = UUID().uuidString /* 669 */
        
        //Upload header Image
        StorageManager.shared.uploadBlogHeaderImage( /* 667 */
            email: email,
            image: headerImage,
            postId: newPostId
        ) { success in
            guard success else { /* 670 */
                return /* 671 */
            }
            StorageManager.shared.downloadUrlForPostHeader(email: email, postId: newPostId) { url in /* 673 */
                guard let headerUrl = url else { /* 674 */
//                    print("Failed to upload url for header") /* 688 */
                    DispatchQueue.main.async { /* 934 */
                        HapticsManager.shared.vibrate(for: .error) /* 935 */
                    }
                    return /* 675 */
                }
                
                //Insert of post into DB
                
                let post = BlogPost(
                    identifier: newPostId, /* 668 change UUID().uuidString to postId */
                    title: title,
                    timestamp: Date().timeIntervalSince1970,
                    headerImageUrl: headerUrl,
                    text: body
                ) /* 644 */
                
                DatabaseManager.shared.insert(blogPost: post, email: email) { [weak self] posted in /* 682 */
                    guard posted else { /* 683 */
//                        print("Failed to post new Blog Article") /* 687 */
                        DispatchQueue.main.async { /* 932 */
                            HapticsManager.shared.vibrate(for: .error) /* 933 */
                        }
                        return /* 684 */
                    }
                    
                    DispatchQueue.main.async { /* 685 */
                        HapticsManager.shared.vibrate(for: .success) /* 931 */
                        self?.didTapCancel() /* 686 */
                    }
                }
            }
        }
    }
}

extension CreateNewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate { /* 653 */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { /* 654 */
        picker.dismiss(animated: true, completion: nil) /* 655 */
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { /* 656 */
        picker.dismiss(animated: true, completion: nil) /* 657 */
        guard let image = info[.originalImage] as? UIImage else { /* 658 */
            return /* 659 */
        }
        selectedHeaderImage = image /* 660 */
        headerImageView.image = image /* 661 */
    }
}
