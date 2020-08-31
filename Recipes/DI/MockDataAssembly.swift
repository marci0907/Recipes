//
//  MockDataAssembly.swift
//  Recipes
//
//  Created by Marcell Magyar on 2020. 09. 09..
//  Copyright © 2020. Marcell Magyar. All rights reserved.
//

import Swinject

final class MockDataAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(RecipeServiceProtocol.self, initializer: MockRecipeService.init)
    }
}
