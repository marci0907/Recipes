//
//  RecipeServiceProtocol.swift
//  Recipes
//
//  Created by Marcell Magyar on 2020. 09. 09..
//  Copyright © 2020. Marcell Magyar. All rights reserved.
//

import RxCocoa
import RxSwift

protocol RecipeServiceProtocol {
    func getRecipes(for screen: ScreenType) -> Observable<[RecipeModel]>
    func fetchRecipes(shouldRebuildDatabase: Bool) -> Completable
    func searchForRecipes(query: String) -> Completable
    func getRecipe(id: Int) -> Observable<RecipeModel>
    func fetchRecipe(id: Int) -> Completable
}
