//
//  DatabaseManager.swift
//  Thoughts
//
//  Created by Nazar Kopeyka on 14.04.2023.
//

import Foundation
import FirebaseFirestore /* 38 */

final class DatabaseManager { /* 39 */
    static let shared = DatabaseManager() /* 40 */
    
    private let database = Firestore.firestore() /* 41 */
    
    private init() {} /* 42 */
    
    public func insert(
        blogPost: BlogPost, /* 92 change from String to BlogPost */
        email: String, /* 93 change from String */ /* 676 change user: User */
        completion: @escaping (Bool) -> Void
    ) { /* 79 */
        let userEmail = email /* 677 copy from 397 and paste */
            .replacingOccurrences(of: ".", with: "_") /* 677 */
            .replacingOccurrences(of: "@", with: "_") /* 677 */
        
        let data: [String: Any] = [ /* 678 */
            "id": blogPost.identifier,
            "title": blogPost.title,
            "body": blogPost.text,
            "created": blogPost.timestamp,
            "headerImageUrl": blogPost.headerImageUrl?.absoluteString ?? ""
        ]
        
        database
            .collection("users") /* 677 */
            .document(userEmail) /* 677 */
            .collection("posts") /* 679 */
            .document(blogPost.identifier) /* 694 */
            .setData(data) { error in /* 680 */ /* 695 change .addDocument to setData */
                completion(error == nil) /* 681 */
            }
    }
    
    public func getAllPosts(
        completion: @escaping ([BlogPost]) -> Void /* 94 change from String to BlogPost */
    ) { /* 80 */
       // Get all users
        //from each user. get posts

        database
            .collection("users") /* 845 */
            .getDocuments { [weak self] snapshot, error in /* 846 */ /* 856 add weak self */
                guard let documents = snapshot?.documents.compactMap({ $0.data() }), /* 847 */
                      error == nil else { /* 848 */
                    return /* 849 */
                }
                
                let emails: [String] = documents.compactMap({ $0["email"] as? String }) /* 850 */
                print(emails) /* 865 */
                guard !emails.isEmpty else { /* 851 */
                    completion([]) /* 852 */
                    return /* 853 */
                }
                
                let group = DispatchGroup() /* 857 */
                var  result: [BlogPost] = [] /* 861 */

                for email in emails { /* 854 */
                    group.enter() /* 858 */
                    self?.getPosts(for: email) { userPosts in /* 855 */
                        defer { /* 859 */
                            group.leave() /* 860 */
                        }
                        result.append(contentsOf: userPosts) /* 862 */
                    }
                }
                
                group.notify(queue: .global()) { /* 863 */
                    print("Feed posts: \(result.count)") /* 866 */
                    completion(result) /* 864 */
                }
            }
    }
    
    public func getPosts(
        for email: String, /* 95 change from String to User */ /* 697 change user: User to email: String */
        completion: @escaping ([BlogPost]) -> Void /* 96 change from Bool to [BlogPost] */
    ) { /* 81 */
        let userEmail = email /* 696 copy from 397 and paste */
            .replacingOccurrences(of: ".", with: "_") /* 696 */
            .replacingOccurrences(of: "@", with: "_") /* 696 */
        database
            .collection("users") /* 698 */
            .document(userEmail) /* 699 */
            .collection("posts") /* 700 */
            .getDocuments { snapshot, error in /* 701 */
                guard let documents = snapshot?.documents.compactMap ({ $0.data() }),
                      error == nil else { /* 702 */
                    return /* 703 */
                }
                
                let posts: [BlogPost] = documents.compactMap({ dictionary in /* 704 */
                    guard let id = dictionary["id"] as? String, /* 705 */
                    let title = dictionary["title"] as? String, /* 705 */
                        let body = dictionary["body"] as? String, /* 705 */
                        let created = dictionary["created"] as? TimeInterval, /* 705 */
                        let imageUrlString = dictionary["headerImageUrl"] as? String else { /* 705 */
                            print("Invalid post fetch conversion")
                            return nil /* 706 */
                        }
                    
                    let post = BlogPost(
                        identifier: id,
                        title: title,
                        timestamp: created,
                        headerImageUrl: URL(string: imageUrlString),
                        text: body
                    ) /* 707 */
                    return post /* 708 */
                })
                completion(posts) /* 709 */
            }
    }
    
    public func insert(
        user: User, /* 97 change from Bool to User */
        completion: @escaping (Bool) -> Void
    ) { /* 82 */
        let documentId = user.email /* 397 */
            .replacingOccurrences(of: ".", with: "_") /* 397 */
            .replacingOccurrences(of: "@", with: "_") /* 397 */
        
        let data = [ /* 398 */
            "email": user.email,
            "name": user.name
        ]
        
        database
            .collection("users") /* 393 */
            .document(documentId) /* 394 */
            .setData(data) { error in /* 395 */
                completion(error == nil) /* 396 */
            }
    }
    
    public func getUser(
        email: String,
        completion: @escaping (User?) -> Void
    ) { /* 489 */
        let documentId = email /* 490 copy from 397 and paste */
            .replacingOccurrences(of: ".", with: "_") /* 490 */
            .replacingOccurrences(of: "@", with: "_") /* 490 */
        
        database
            .collection("users") /* 491 copy from 393 and paste */
            .document(documentId) /* 491 */
            .getDocument { snapshot, error in /* 492 */
                guard let data = snapshot?.data() as? [String: String],
                      let name = data["name"], /* 495 */
                      error == nil else { /* 493 */
                    return /* 494 */
                }
                

                var ref = data["profile_photo"] /* 499 */
                let user = User(name: name, email: email, profilePictureRef: ref) /* 496 */
                completion(user) /* 497 */
            }
    }
    
    func updateProfilePhoto(
        email: String,
        completion: @escaping (Bool) -> Void
    ) { /* 544 */
        let path = email
            .replacingOccurrences(of: "@", with: "_") /* 546 */
            .replacingOccurrences(of: ".", with: "_") /* 546 */
        
        let photoReference = "profile_pictures/\(path)/photo.png" /* 545 */
        
        let dbRef = database 
            .collection("users") /* 547 */
            .document(path) /* 548 */
        
        dbRef.getDocument { snapshot, error in /* 549 */
            guard var data = snapshot?.data(), error == nil else { /* 550 */
                return /* 551 */
            }
            
            data["profile_photo"] = photoReference /* 552 */
            
            dbRef.setData(data) { error in /* 553 */
                completion(error == nil) /* 554 */
            }
        }
    }
}
