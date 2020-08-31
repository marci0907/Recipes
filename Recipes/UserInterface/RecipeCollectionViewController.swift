//
//  RecipeCollectionViewController.swift
//  Recipes
//
//  Created by Marcell Magyar on 2020. 11. 20..
//  Copyright © 2020. Marcell Magyar. All rights reserved.
//

import RxSwift

class RecipeCollectionViewController: UIViewController, CollectionViewTransitionable {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    let bag = DisposeBag()

    var collectionView: UICollectionView!
    var sourceCell: UICollectionViewCell!

    let collectionViewCellReuseId = "RecipeCell"
    let collectionViewCellType = RecipeCollectionViewCell.self

    let service: RecipeServiceProtocol

    init(service: RecipeServiceProtocol) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.delegate = self

        setupUI()
    }

    func setupUI() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        collectionView.rx.setDelegate(self)
            .disposed(by: bag)

        view.backgroundColor = .systemBackground
        tabBarController?.tabBar.barTintColor = .systemBackground

        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        collectionView.register(collectionViewCellType, forCellWithReuseIdentifier: collectionViewCellReuseId)

        collectionView.indicatorStyle = .black
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }

    func pushDetailViewController(_ detailVC: UIViewController) {
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension RecipeCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewContentWidth = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right))

        if indexPath.row == 0 {
            return CGSize(width: collectionViewContentWidth, height: 400)
        } else {
            return CGSize(width: (collectionViewContentWidth - 15) / 2, height: 200)
        }
    }
}

extension RecipeCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sourceCell = collectionView.cellForItem(at: indexPath) as? RecipeCollectionViewCell else {
            return
        }
        self.sourceCell = sourceCell

        let detailVC = DetailViewController(recipe: sourceCell.recipe, service: service)
        pushDetailViewController(detailVC)
    }
}

extension RecipeCollectionViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomNavigationTransition(operation: operation, duration: 0.5)
    }
}
