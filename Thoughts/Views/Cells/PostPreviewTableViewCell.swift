//
//  PostPreviewTableViewCell.swift
//  Thoughts
//
//  Created by Nazar Kopeyka on 17.04.2023.
//

import UIKit

class PostPreviewTableViewCellViewModel { /* 747 */
    let title: String /* 748 */
    let imageUrl: URL? /* 749 */
    var imageData: Data? /* 750 */
    
    init(title: String, imageUrl: URL?) { /* 750 */
        self.title = title /* 751 */
        self.imageUrl = imageUrl /* 752 */
    }
}

class PostPreviewTableViewCell: UITableViewCell {
    static let identifier = "PostPreviewTableViewCell" /* 718 */
    
    private let postImageView: UIImageView = { /* 729 */
        let imageView = UIImageView() /* 730 */
        imageView.layer.masksToBounds = true /* 731 */
        imageView.clipsToBounds = true /* 732 */
        imageView.layer.cornerRadius = 8 /* 733 */
        imageView.contentMode = .scaleAspectFill /* 734 */
        return imageView /* 735 */
    }()
    
    private let postTitleLabel: UILabel = { /* 737 */
        let label = UILabel() /* 738 */
        label.numberOfLines = 0 /* 739 */
        label.font = .systemFont(ofSize: 20, weight: .medium) /* 740 */
        return label /* 741 */
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) { /* 719 */
        super.init(style: style, reuseIdentifier: reuseIdentifier) /* 720 */
        contentView.clipsToBounds = true /* 721 */
        contentView.addSubview(postImageView) /* 736 */
        contentView.addSubview(postTitleLabel) /* 742 */
    }
    
    required init?(coder: NSCoder) { /* 722 */
        fatalError() /* 723 */
    }
    
    override func layoutSubviews() { /* 724 */
        super.layoutSubviews() /* 725 */
        postImageView.frame = CGRect(
            x: separatorInset.left,
            y: 5,
            width: contentView.height-10,
            height: contentView.height-10
        ) /* 745 */
        postTitleLabel.frame = CGRect(
            x: postImageView.right+5,
            y: 5,
            width: contentView.width-5-separatorInset.left-postImageView.width,
            height: contentView.height-10
        ) /* 746 */
    }
    
    override func prepareForReuse() { /* 726 */
        super.prepareForReuse() /* 727 */
        postTitleLabel.text = nil /* 743 */
        postImageView.image = nil /* 744 */
    }
    
    func configure(with viewModel: PostPreviewTableViewCellViewModel) { /* 728 */ /* 753 change String */
        postTitleLabel.text = viewModel.title /* 754 */
        
        if let data = viewModel.imageData { /* 755 */
            postImageView.image = UIImage(data: data) /* 756 */
        }
        else if let url = viewModel.imageUrl { /* 757 */
            //Fetch image & cache
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in /* 758 */
                guard let data = data else { /* 759 */
                    return /* 760 */
                }
                
                viewModel.imageData = data /* 761 */
                DispatchQueue.main.async { /* 762 */
                    self?.postImageView.image = UIImage(data: data) /* 763 */
                }
            }
            task.resume() /* 764 */
        }
    }

}
