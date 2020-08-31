//
//  RepositoryProtocol.swift
//  Recipes
//
//  Created by Marcell Magyar on 2020. 09. 16..
//  Copyright © 2020. Marcell Magyar. All rights reserved.
//

import RxSwift

enum ScreenType {
    case home, results
}

protocol RepositoryProtocol {
    associatedtype ModelType
    func saveData(data: [ModelType]) -> Completable
    func rebuildDatabase(database: [ModelType], screen: ScreenType) -> Completable
    func getAllData(screen: ScreenType) -> Observable<[ModelType]>
    func get(forId: Int) -> Observable<ModelType>
    func deleteAll() -> Completable
    func update(data: ModelType) -> Completable
}
