//
//  PayWallDescriptionView.swift
//  Thoughts
//
//  Created by Nazar Kopeyka on 15.04.2023.
//

import UIKit

class PayWallDescriptionView: UIView {

    private let descriptorLabel: UILabel = { /* 203 */
        let label = UILabel() /* 204 */
        label.textAlignment = .center /* 205 */
        label.font = .systemFont(ofSize: 26, weight: .medium) /* 206 */
        label.numberOfLines = 0 /* 207 */
        label.text = "Join Thoughts Premium to read unlimited articles and browse thousands of posts!" /* 227 */
        return label /* 208 */
    }()
    
    private let priceLabel: UILabel = { /* 209  */
        let label = UILabel() /* 210 */
        label.textAlignment = .center /* 211 */
        label.font = .systemFont(ofSize: 22, weight: .regular) /* 212 */
        label.numberOfLines = 1 /* 213 */
        label.text = "$4.99 / month" /* 226 */
        return label /* 214 */
    }()
    
    override init(frame: CGRect) { /* 215 */
        super.init(frame: frame) /* 216 */
        clipsToBounds = true /* 217 */
        addSubview(priceLabel) /* 222 */
        addSubview(descriptorLabel) /* 223 */
    }
    
    required init?(coder: NSCoder) { /* 218 */
        fatalError() /* 219 */
    }
    
    override func layoutSubviews() { /* 220 */
        super.layoutSubviews() /* 221 */
        descriptorLabel.frame = CGRect(x: 20, y: 0, width: width - 40, height: height / 2) /* 224 */
        priceLabel.frame = CGRect(x: 20, y: height / 2, width: width - 40, height: height / 2) /* 225 */
    }

}
