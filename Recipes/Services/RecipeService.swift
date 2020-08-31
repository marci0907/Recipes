//
//  RecipeService.swift
//  Recipes
//
//  Created by Marcell Magyar on 2020. 09. 09..
//  Copyright © 2020. Marcell Magyar. All rights reserved.
//

import RxSwift

class RecipeService: RecipeServiceProtocol {

    enum Endpoint {
        case randomRecipes
        case searchRecipes
        case recipe(Int)

        var url: String {
            switch self {
            case .randomRecipes:
                return "recipes/random"
            case .searchRecipes:
                return "recipes/complexSearch"
            case .recipe(let id):
                return "recipes/\(id)/information"
            }
        }
    }

    let errorHandler: ErrorHandler
    let networkManager: NetworkManager
    let repository: RecipeRepository

    let bag = DisposeBag()

    init(errorHandler: ErrorHandler, networkManager: NetworkManager, repository: RecipeRepository) {
        self.errorHandler = errorHandler
        self.networkManager = networkManager
        self.repository = repository
    }

    func getRecipes(for screen: ScreenType) -> Observable<[RecipeModel]> {
        repository.getAllData(screen: screen)
    }

    func fetchRecipes(shouldRebuildDatabase: Bool) -> Completable {
        let request: Single<RecipeArray> = networkManager.sendRequest(method: .get, toEndPoint: Endpoint.randomRecipes.url, withParameters: ["number": "50", "includeNutrition": "false"])
        return request
            .flatMapCompletable { [unowned self] in
                return shouldRebuildDatabase
                    ? self.repository.rebuildDatabase(database: $0.recipes ?? [], screen: .home)
                    : self.repository.saveData(data: $0.recipes ?? []) }
            .showErrorAlert(with: errorHandler)
            .catchError { _ in .empty() }
    }

    func searchForRecipes(query: String) -> Completable {
        let modifiedQuery = query.replacingOccurrences(of: " ", with: "")
        let request: Single<SearchModel> = networkManager.sendRequest(method: .get, toEndPoint: Endpoint.searchRecipes.url, withParameters: ["query": modifiedQuery, "number": "50"])
        return request
            .flatMapCompletable { [unowned self] in self.repository.rebuildDatabase(database: $0.results ?? [], screen: .results) }
            .showErrorAlert(with: errorHandler)
            .catchError { _ in .empty() }
    }

    func getRecipe(id: Int) -> Observable<RecipeModel> {
        repository.get(forId: id)
    }

    func fetchRecipe(id: Int) -> Completable {
        let request: Single<RecipeModel> = networkManager.sendRequest(method: .get, toEndPoint: Endpoint.recipe(id).url, withParameters: ["includeNutrition": "true"])
        return request
            .flatMapCompletable { [unowned self] recipe in self.repository.update(data: recipe) }
            .showErrorAlert(with: errorHandler)
            .catchError { _ in .empty() }
    }
}
