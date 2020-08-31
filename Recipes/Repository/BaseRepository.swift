//
//  Repository.swift
//  Recipes
//
//  Created by Marcell Magyar on 2020. 09. 16..
//  Copyright © 2020. Marcell Magyar. All rights reserved.
//

import RxRelay
import RxSwift

enum RepositoryError: Error {
    case recipeNotFound

    var localizedDescription: String {
        switch self {
        case .recipeNotFound:
            return "Requested recipe is not found."
        }
    }
}

class BaseRepository<ModelType>: RepositoryProtocol {
    typealias ModelType = RecipeModel

    private let homeRecipeRelay = BehaviorRelay<[RecipeModel]>(value: [])
    private let resultsRecipeRelay = BehaviorRelay<[RecipeModel]>(value: [])
    private let sumRecipeRelay = BehaviorRelay<[RecipeModel]>(value: [])

    private func saveToWholeDatabase(_ data: [RecipeModel]) {
        self.sumRecipeRelay.accept(self.sumRecipeRelay.value + data)
    }

    // used during infinite scrolling -> homeRecipeRelay
    func saveData(data: [RecipeModel]) -> Completable {
        Completable.create { [unowned self] completable in
            self.homeRecipeRelay.accept(self.homeRecipeRelay.value + data)
            // we also save the data to the sum relay
            saveToWholeDatabase(data)
            completable(.completed)
            return Disposables.create()
        }
    }

    // used when opening app, reloading or searcing -> all relays
    func rebuildDatabase(database: [RecipeModel], screen: ScreenType) -> Completable {
        Completable.create { [unowned self] completable in
            if screen == .home {
                self.homeRecipeRelay.accept(database)
            } else {
                self.resultsRecipeRelay.accept(database)
            }
            // we also save the data to the sum relay
            saveToWholeDatabase(database)
            completable(.completed)
            return Disposables.create()
        }
    }

    // used to get all data on the given screen -> homeRecipeRelay or resultsRecipeRelay
    func getAllData(screen: ScreenType) -> Observable<[RecipeModel]> {
        if screen == .home {
            return homeRecipeRelay.asObservable()
        } else {
            return resultsRecipeRelay.asObservable()
        }
    }

    // used to get recipe from the whole repo -> sumRecipeRelay
    func get(forId: Int) -> Observable<RecipeModel> {
        sumRecipeRelay
            .asObservable()
            .map { recipes in
                guard let resultRecipe = recipes.first(where: { $0.id == forId }) else {
                    throw RepositoryError.recipeNotFound
                }
                return resultRecipe
            }
    }

    // still not used
    func deleteAll() -> Completable {
        Completable.create { [unowned self] completable in
            self.homeRecipeRelay.accept([])
            completable(.completed)
            return Disposables.create()
        }
    }

    // used to update recipe from whole repo with more info -> sumRecipeRelay
    func update(data: RecipeModel) -> Completable {
        Completable.create { [unowned self] completable in
            if let recipeToBeUpdated = self.sumRecipeRelay.value.first(where: { $0.id == data.id }),
               let index = self.sumRecipeRelay.value.firstIndex(where: { $0.id == recipeToBeUpdated.id }){
                var newRecipesArray = self.sumRecipeRelay.value.filter { $0.id != recipeToBeUpdated.id }
                newRecipesArray.insert(data, at: index)
                self.sumRecipeRelay.accept(newRecipesArray)
                completable(.completed)
            }
            return Disposables.create()
        }
    }
}
