//
//  MockRecipeService.swift
//  Recipes
//
//  Created by Marcell Magyar on 2020. 09. 09..
//  Copyright © 2020. Marcell Magyar. All rights reserved.
//

import RxSwift

class MockRecipeService: RecipeServiceProtocol {

    func getRecipes(for screen: ScreenType) -> Observable<[RecipeModel]> {
        Observable.just([RecipeModel(title: "asd")])
    }

    func fetchRecipes(shouldRebuildDatabase: Bool) -> Completable {
        Completable.create { completable in
            completable(.completed)
            return Disposables.create()
        }
    }

    func searchForRecipes(query: String) -> Completable {
        Completable.create { completable in
            completable(.completed)
            return Disposables.create()
        }
    }

    func getRecipe(id: Int) -> Observable<RecipeModel> {
        Observable.just(RecipeModel(title: "asd"))
    }

    func fetchRecipe(id: Int) -> Completable {
        Completable.create { completable in
            completable(.completed)
            return Disposables.create()
        }
    }
}
