//
//  CollectionViewTransitionable.swift
//  Recipes
//
//  Created by Marcell Magyar on 2020. 11. 21..
//  Copyright © 2020. Marcell Magyar. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewTransitionable: UIViewController {
    var sourceCell: UICollectionViewCell! { get }
    var collectionView: UICollectionView! { get }
}
