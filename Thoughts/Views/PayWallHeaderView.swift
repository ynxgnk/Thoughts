//
//  PayWallHeaderView.swift
//  Thoughts
//
//  Created by Nazar Kopeyka on 15.04.2023.
//

import UIKit

class PayWallHeaderView: UIView { /* 136 */

    //Header Image
    private let headerImageView: UIImageView = { /* 124 */
        let imageView = UIImageView(image: UIImage(systemName: "crown.fill")) /* 125 */
        imageView.frame = CGRect(x: 0, y: 0, width: 110, height: 110) /* 147 */
        imageView.tintColor = .white /* 126 */
        imageView.contentMode = .scaleAspectFit /* 127 */
        return imageView /* 128 */
    }()
    
    override init(frame: CGRect) { /* 137 */
        super.init(frame: frame) /* 138 */
        clipsToBounds = true /* 139 */
        addSubview(headerImageView) /* 140 */
        backgroundColor = .systemPink /* 141 */
    }
    
    required init?(coder: NSCoder) { /* 142 */
        fatalError() /* 143 */
    }
    
    override func layoutSubviews() { /* 144 */
        super.layoutSubviews() /* 145 */
        headerImageView.frame = CGRect(x: (bounds.width - 110)/2, y: (bounds.height - 110)/2, width: 110, height: 110) /* 146 */
    }

}
