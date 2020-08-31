//
//  RecipeCollectionViewCell.swift
//  Recipes
//
//  Created by Marcell Magyar on 2020. 10. 15..
//  Copyright © 2020. Marcell Magyar. All rights reserved.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    var recipe: RecipeModel! {
        didSet {
            recipeName.text = recipe.title
            image.setImage(for: recipe.image ?? "")
        }
    }

    var image: UIImageView = {
        let view = UIImageView()
        return view
    }()

    var recipeName: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        addSubview(image)
        addSubview(recipeName)

        translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        recipeName.translatesAutoresizingMaskIntoConstraints = false

        image.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        image.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        image.bottomAnchor.constraint(equalTo: recipeName.topAnchor, constant: -10).isActive = true

        recipeName.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        recipeName.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        recipeName.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10).isActive = true
        recipeName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
}
