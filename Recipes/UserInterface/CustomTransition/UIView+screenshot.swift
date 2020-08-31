//
//  UIView+screenshot.swift
//  Recipes
//
//  Created by Marcell Magyar on 2020. 11. 21..
//  Copyright © 2020. Marcell Magyar. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var screenshot: UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)

        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!

        UIGraphicsEndImageContext()
        return image
    }
}
