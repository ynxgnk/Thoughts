//
//  PostHeaderTableViewCell.swift
//  Thoughts
//
//  Created by Nazar Kopeyka on 17.04.2023.
//

import UIKit

class PostHeaderTableViewCellViewModel { /* 789 */
    let imageUrl: URL? /* 790 */
    var imageData: Data? /* 791 */
    
    init(imageUrl: URL?) { /* 792 */
        self.imageUrl = imageUrl /* 793 */
    }
}

class PostHeaderTableViewCell: UITableViewCell {
    static let identifier = "PostHeaderTableViewCell" /* 786 */
        
    private let postImageView: UIImageView = { /* 787 copy from PostPreviewTableViewCellViewModel and paste */
        let imageView = UIImageView() /* 787 */
        imageView.layer.masksToBounds = true /* 787 */
        imageView.clipsToBounds = true /* 787 */
        imageView.contentMode = .scaleAspectFill /* 787 */
        return imageView /* 787 */
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) { /* 787 */
        super.init(style: style, reuseIdentifier: reuseIdentifier) /* 787 */
        contentView.clipsToBounds = true /* 787 */
        contentView.addSubview(postImageView) /* 787 */
    }
    
    required init?(coder: NSCoder) { /* 787 */
        fatalError() /* 787 */
    }
    
    override func layoutSubviews() { /* 787 */
        super.layoutSubviews() /* 787 */
        postImageView.frame = contentView.bounds /* 788 */
    }
    
    override func prepareForReuse() { /* 787 */
        super.prepareForReuse() /* 787 */
        postImageView.image = nil /* 787 */
    }
    
    func configure(with viewModel: PostHeaderTableViewCellViewModel) { /* 787 */
        if let data = viewModel.imageData { /* 787 */
            postImageView.image = UIImage(data: data) /* 787 */
        }
        else if let url = viewModel.imageUrl { /* 787 */
            //Fetch image & cache
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in /* 787 */
                guard let data = data else { /* 787 */
                    return /* 787 */
                }
                
                viewModel.imageData = data /* 787 */
                DispatchQueue.main.async { /* 787 */
                    self?.postImageView.image = UIImage(data: data) /* 787 */
                }
            }
            task.resume() /* 787 */
        }
    }
}
