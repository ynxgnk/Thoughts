//
//  StorageManager.swift
//  Thoughts
//
//  Created by Nazar Kopeyka on 14.04.2023.
//

import Foundation
import FirebaseStorage /* 48 */

final class StorageManager { /* 49 */
    static let shared = StorageManager() /* 50 */
    
    private let container = Storage.storage() /* 51 */ /* 98 add reference() gives a reference to storage */ /* 530 remove .reference() */
    
    private init() {} /* 52 */
    
    public func uploadUserProfilePicture(
        email: String,
        image: UIImage?,
        completion: @escaping (Bool) -> Void
    ) { /* 99 */
        let path = email
            .replacingOccurrences(of: "@", with: "_") /* 534 */
            .replacingOccurrences(of: ".", with: "_") /* 535 */
        
        guard let pngData = image?.pngData() else { /* 532 */
            return /* 533 */
        }
        
        container
            .reference(withPath: "profile_pictures/\(path)/photo.png") /* 531 */
            .putData(pngData, metadata: nil) { metadata, error in /* 536 */
                guard metadata != nil, error == nil else { /* 537 */
                    completion(false) /* 539 */
                    return /* 538 */
                }
                completion(true) /* 540 */
            }
    }
    
    public func downloadUrlForProfilePicture(
//        user: User,
        path: String, /* 560 */
        completion: @escaping (URL?) -> Void
    ) { /* 100 */
        container.reference(withPath: path) /* 561 */
            .downloadURL { url, _ in /* 562 */
                completion(url) /* 563 */
            }
    }
    
    public func uploadBlogHeaderImage(
        email: String, /* 662 add email */
        image: UIImage,
        postId: String,
        completion: @escaping (Bool) -> Void
    ) { /* 101 */
        let path = email
            .replacingOccurrences(of: "@", with: "_") /* 663 copy from 534 and paste */
            .replacingOccurrences(of: ".", with: "_") /* 663 */
        
        guard let pngData = image.pngData() else { /* 663 */
            return /* 663 */
        }
        
        container
            .reference(withPath: "post_headers/\(path)/\(postId).png") /* 663 */
            .putData(pngData, metadata: nil) { metadata, error in /* 663 */
                guard metadata != nil, error == nil else { /* 663 */
                    completion(false) /* 663 */
                    return /* 663 */
                }
                completion(true) /* 663 */
            }
    }
    
    public func downloadUrlForPostHeader(
        email: String,
        postId: String,
        completion: @escaping (URL?) -> Void
    ) { /* 102 */
        let emailComponent = email
            .replacingOccurrences(of: "@", with: "_") /* 664 copy from 534 and paste */
            .replacingOccurrences(of: ".", with: "_") /* 664 */
        
        container
            .reference(withPath: "post_headers/\(emailComponent)/\(postId).png") /* 664 */
            .downloadURL { url, _ in /* 665 */
                completion(url) /* 666 */
            }
    }
}
