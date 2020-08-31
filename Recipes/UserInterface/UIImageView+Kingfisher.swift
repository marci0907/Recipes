//
//  UIImageView+Kingfisher.swift
//  Recipes
//
//  Created by Marcell Magyar on 2020. 10. 16..
//  Copyright © 2020. Marcell Magyar. All rights reserved.
//

import Kingfisher

public extension UIImageView {
    func setImage(for urlString: String, isRounded: Bool = true) {
        guard let url = URL(string: urlString) else {
            return
        }
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        self.kf.indicatorType = .activity
        var options = KingfisherOptionsInfo()

        // setting image twice to have both rounded and not rounded image in cache
        self.kf.setImage(with: url)
        if isRounded {
            options.append(.processor(processor))
            self.kf.setImage(with: url, options: options)
        }
    }
}
