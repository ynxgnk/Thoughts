//
//  Extensions.swift
//  Thoughts
//
//  Created by Nazar Kopeyka on 15.04.2023.
//

import Foundation
import UIKit /* 152 */

extension UIView { /* 153 */
    var width: CGFloat { /* 154 */
        frame.size.width /* 155 */
    }
    
    var height: CGFloat { /* 156 */
        frame.size.height /* 157 */
    }
    
    var left: CGFloat { /* 158 */
        frame.origin.x /* 159 */
    }
    
    var right: CGFloat { /* 160 */
        left + width /* 161 */
    }
    
    var top: CGFloat { /* 162 */
        frame.origin.y /* 163 */
    }
    
    var bottom: CGFloat { /* 164 */
        top + height /* 165 */
    }
}
