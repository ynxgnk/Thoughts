//
//  SignInHeaderView.swift
//  Thoughts
//
//  Created by Nazar Kopeyka on 16.04.2023.
//

import UIKit

class SignInHeaderView: UIView {

    private let imageView: UIImageView = { /* 305 */
        let imageView = UIImageView(image: UIImage(named: "logo")) /* 306 */
        imageView.contentMode = .scaleAspectFit /* 307 */
        imageView.backgroundColor = .systemPink /* 308 */
        return imageView /* 309 */
    }()
    
    private let label: UILabel = { /* 310 */
        let label = UILabel() /* 311 */
        label.textAlignment = .center /* 312 */
        label.numberOfLines = 0 /* 313 */
        label.font = .systemFont(ofSize: 20, weight: .medium) /* 314 */
        label.text = "Explore millions of articles!" /* 315 */
        return label /* 316 */
    }()
    
    override init(frame: CGRect) { /* 298 */
        super.init(frame: frame) /* 299 */
        clipsToBounds = true /* 300 */
        addSubview(label) /* 317 */
        addSubview(imageView) /* 318 */
    }
    
    required init?(coder: NSCoder) { /* 301 */
        fatalError() /* 302 */
    }
    
    override func layoutSubviews() { /* 303 */
        super.layoutSubviews() /* 304 */
        
        let size: CGFloat = width / 4 /* 319 */
        imageView.frame = CGRect(x: (width-size)/2, y: 10, width: size, height: size) /* 320 */
        label.frame = CGRect(x: 20, y: imageView.bottom+10, width: width-40, height: height-size-30) /* 321 */
    }

}
