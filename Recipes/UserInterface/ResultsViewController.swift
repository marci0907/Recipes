//
//  SearchViewController.swift
//  Recipes
//
//  Created by Marcell Magyar on 2020. 11. 15..
//  Copyright © 2020. Marcell Magyar. All rights reserved.
//

import RxSwift

final class ResultsViewController: RecipeCollectionViewController {

    var resultSubject = PublishSubject<[RecipeModel]>()

    override func viewDidLoad() {
        super.viewDidLoad()

        service.getRecipes(for: .results)
            .bind(to: collectionView.rx.items(cellIdentifier: collectionViewCellReuseId, cellType: collectionViewCellType)) { row, element, cell in
                cell.recipe = element
            }
            .disposed(by: bag)
    }

    override func pushDetailViewController(_ detailVC: UIViewController) {
        present(detailVC, animated: true, completion: nil)
    }
}
