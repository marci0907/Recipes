//
//  DetailViewController.swift
//  Recipes
//
//  Created by Marcell Magyar on 2020. 11. 23..
//  Copyright © 2020. Marcell Magyar. All rights reserved.
//

import RxSwift

class DetailViewController: UIViewController {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private enum State {
        case loading
        case loaded
        case error(String)
    }

    let bag = DisposeBag()

    var recipe: RecipeModel

    var image: UIImageView!
    var contentView: UIView!
    var errorLabel: UILabel!
    var errorView: UIView!
    var titleLabel: UILabel!
    var firstNutrientLabel: UILabel!
    var activityIndicator: UIActivityIndicatorView!

    private var state: State = .loading {
        didSet {
            setupState()
        }
    }

    let service: RecipeServiceProtocol

    init(recipe: RecipeModel, service: RecipeServiceProtocol) {
        self.recipe = recipe
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        service.fetchRecipe(id: recipe.id ?? 0)
            .do(onSubscribe: { [unowned self] in self.state = .loading })
            .do(onDispose: { [unowned self] in self.state = .loaded })
            .subscribe()
            .disposed(by: bag)

        let recipeStream = service.getRecipe(id: recipe.id ?? 0)
            .do(onError: { [unowned self] error in
                let repoError = error as? RepositoryError
                self.state = .error(repoError?.localizedDescription ?? error.localizedDescription)
            })
            .share()

        recipeStream
            .compactMap { $0.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: bag)

        recipeStream
            .compactMap { $0.nutrition?.nutrients?.first }
            .map { "\($0.title ?? ""): \($0.amount ?? 0.0) \($0.unit ?? "")"}
            .bind(to: firstNutrientLabel.rx.text)
            .disposed(by: bag)
    }

    private func setupState() {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
            contentView.isHidden = true
            errorView.isHidden = true
        case .loaded:
            activityIndicator.stopAnimating()
            contentView.isHidden = false
            errorView.isHidden = true
        case .error(let error):
            activityIndicator.stopAnimating()
            contentView.isHidden = true
            errorView.isHidden = false
            errorLabel.text = error
        }
    }

    private func setupUI() {
        view.backgroundColor = .white

        // image
        image = UIImageView(frame: .zero)

        view.addSubview(image)

        image.translatesAutoresizingMaskIntoConstraints = false

        image.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        image.heightAnchor.constraint(equalToConstant: 280).isActive = true

        // error view
        errorView = UIView(frame: .zero)

        view.addSubview(errorView)

        errorView.translatesAutoresizingMaskIntoConstraints = false

        errorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        errorView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        errorView.topAnchor.constraint(equalTo: image.bottomAnchor).isActive = true
        errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        // error label
        errorLabel = UILabel(frame: .zero)
        errorLabel.textColor = .red
        errorLabel.font = UIFont.systemFont(ofSize: 30)
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0

        errorView.addSubview(errorLabel)

        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        errorLabel.leftAnchor.constraint(equalTo: errorView.leftAnchor, constant: 25).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: errorView.rightAnchor, constant: -25).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: errorView.centerYAnchor).isActive = true

        // content view
        contentView = UIView(frame: .zero)

        view.addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: image.bottomAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        // title label
        titleLabel = UILabel(frame: .zero)
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 30)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        contentView.addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25).isActive = true

        // first nutrient
        firstNutrientLabel = UILabel(frame: .zero)
        firstNutrientLabel.textColor = .black
        firstNutrientLabel.font = UIFont.systemFont(ofSize: 20)
        firstNutrientLabel.textAlignment = .center
        firstNutrientLabel.numberOfLines = 0

        contentView.addSubview(firstNutrientLabel)

        firstNutrientLabel.translatesAutoresizingMaskIntoConstraints = false

        firstNutrientLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
        firstNutrientLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25).isActive = true
        firstNutrientLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50).isActive = true

        activityIndicator = UIActivityIndicatorView(frame: .zero)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .black

        view.insertSubview(activityIndicator, aboveSubview: contentView)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        image.setImage(for: recipe.image ?? "", isRounded: false)
    }
}
