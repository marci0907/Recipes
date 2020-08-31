import Kingfisher
import RxSwift

final class HomeViewController: RecipeCollectionViewController {
    
    private var refreshButton: UIBarButtonItem!
    private var searchUpdaterView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        service.fetchRecipes(shouldRebuildDatabase: true)
            .subscribe()
            .disposed(by: bag)

        service.getRecipes(for: .home)
            .bind(to: collectionView.rx.items(cellIdentifier: collectionViewCellReuseId, cellType: collectionViewCellType)) { row, element, cell in
                cell.recipe = element
            }
            .disposed(by: bag)

        collectionView.rx.prefetchItems
            .withLatestFrom(service.getRecipes(for: .home)) { ($0, $1) }
            .subscribe(onNext: { indexPath, recipes in
                var newRecipes = [RecipeModel]()
                indexPath.forEach {
                    newRecipes.append(recipes[$0.row])
                }
                ImagePrefetcher(urls: newRecipes.compactMap { URL(string: $0.image ?? "") }).start()
            })
            .disposed(by: bag)

        collectionView.rx.contentOffset
            .skip(1)
            .buffer(timeSpan: RxTimeInterval.never, count: 2, scheduler: MainScheduler.instance)
            .filter { ($0.first?.y ?? 0.0) < ($0.last?.y ?? 0.0) }
            .filter { [unowned self] _ in self.collectionView.isNearBottomEdge(edgeOffset: 250.0) }
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .flatMap { [unowned self] _ in self.service.fetchRecipes(shouldRebuildDatabase: false) }
            .subscribe()
            .disposed(by: bag)

        refreshButton.rx.tap
            .do(onNext: { [unowned self] in self.collectionView.setContentOffset(.init(x: -15, y: -140), animated: true) })
            .flatMap { [unowned self] in self.service.fetchRecipes(shouldRebuildDatabase: true) }
            .subscribe()
            .disposed(by: bag)
    }

    @objc
    private func handleSearchTokenTapped(_ sender: UIButton) {
        navigationItem.searchController?.searchBar.text = sender.currentTitle
        navigationItem.searchController?.searchBar.resignFirstResponder()
    }

    override func setupUI() {
        super.setupUI()
        // ez a más színű navbar miatt kellett
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
        navigationItem.rightBarButtonItem = refreshButton

        let resultsViewController = ResultsViewController(service: service)
        let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.obscuresBackgroundDuringPresentation = false

        // bug: első két karakternél fos
        searchController.searchBar.rx.text
            .orEmpty
            .filter { !$0.isEmpty && $0.count > 2 }
            .do(onNext: { [weak resultsViewController] _ in
                resultsViewController?.collectionView.setContentOffset(.init(x: -15, y: -100), animated: true)
            })
            .flatMap { [unowned self] in self.service.searchForRecipes(query: $0) }
            .subscribe()
            .disposed(by: bag)
        
        searchController.rx.didPresent
            .do(onNext: { [unowned self] in
                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.searchUpdaterView.alpha = 1
                }
            })
            .subscribe()
            .disposed(by: bag)

        searchController.rx.willDismiss
            .do(onNext: { [unowned self] in self.searchUpdaterView.alpha = 0 })
            .subscribe()
            .disposed(by: bag)

        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.searchTextField.leftView?.tintColor = .black

        setupSearchUpdaterView()
    }

    private func setupSearchUpdaterView() {
        // searchUpdaterView
        searchUpdaterView = UIView(frame: .zero)
        searchUpdaterView.backgroundColor = .init(white: 0, alpha: 0.8)

        view.addSubview(searchUpdaterView)

        searchUpdaterView.translatesAutoresizingMaskIntoConstraints = false

        searchUpdaterView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchUpdaterView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        searchUpdaterView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchUpdaterView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        searchUpdaterView.alpha = 0

        let screenWidth = UIScreen.main.bounds.width

        // firstButton
        let firstButton = UIButton(frame: .zero)
        firstButton.backgroundColor = .white
        firstButton.setTitleColor(.black, for: .normal)
        firstButton.layer.cornerRadius = 5.0
        firstButton.setTitle("Burger", for: .normal)

        searchUpdaterView.addSubview(firstButton)

        firstButton.translatesAutoresizingMaskIntoConstraints = false

        firstButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        firstButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        firstButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        firstButton.widthAnchor.constraint(equalToConstant: screenWidth / 2 - 15).isActive = true

        // secondButton
        let secondButton = UIButton(frame: .zero)
        secondButton.backgroundColor = .white
        secondButton.setTitleColor(.black, for: .normal)
        secondButton.layer.cornerRadius = 5.0
        secondButton.setTitle("Pizza", for: .normal)

        searchUpdaterView.addSubview(secondButton)

        secondButton.translatesAutoresizingMaskIntoConstraints = false

        secondButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        secondButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        secondButton.leftAnchor.constraint(equalTo: firstButton.rightAnchor, constant: 10).isActive = true
        secondButton.widthAnchor.constraint(equalToConstant: screenWidth / 2 - 15).isActive = true

        // thirdButton
        let thirdButton = UIButton(frame: .zero)
        thirdButton.backgroundColor = .white
        thirdButton.setTitleColor(.black, for: .normal)
        thirdButton.layer.cornerRadius = 5.0
        thirdButton.setTitle("Taco", for: .normal)

        searchUpdaterView.addSubview(thirdButton)

        thirdButton.translatesAutoresizingMaskIntoConstraints = false

        thirdButton.topAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: 10).isActive = true
        thirdButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        thirdButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        thirdButton.widthAnchor.constraint(equalToConstant: screenWidth / 2 - 15).isActive = true

        [firstButton, secondButton, thirdButton].forEach { button in
            button.addTarget(self, action: #selector(self.handleSearchTokenTapped(_:)), for: .touchUpInside)
        }
    }
}

// MARK: - Near Edge

private extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return contentOffset.y + frame.size.height + edgeOffset > contentSize.height
    }
}
