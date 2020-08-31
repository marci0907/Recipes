//
//  CommonAssembly.swift
//  Recipes
//
//  Created by Marcell Magyar on 2020. 09. 09..
//  Copyright © 2020. Marcell Magyar. All rights reserved.
//
import Alamofire
import Swinject

final class CommonAssembly: Assembly {

    private enum Constants {
//        static let apiKey = "?apiKey=66a6212d3f92444eabe45c75fc71817c" //t
        static let apiKey = "?apiKey=0d5dd755e24341fa93526c5477672f9a" //g
//        static let apiKey = "?apiKey=f9036fa75d564e8aacb2e32cda7d4b0c" //h
//        static let apiKey = "?apiKey=6bdfa65f152c4b33a40741114ad49dca" //s
        static let baseUrl = "https://api.spoonacular.com/"
        static let contentTypeName = "Content-Type"
        static let contentTypeValue = "application/json"
    }

    func assemble(container: Container) {
        container.register(NetworkManager.self) { _ in
            NetworkManager(
                apiKey: Constants.apiKey,
                baseUrl: Constants.baseUrl,
                headers: [HTTPHeader(name: Constants.contentTypeName, value: Constants.contentTypeValue)]
            )
        }
        container.autoregister(RecipeRepository.self, initializer: RecipeRepository.init)
    }
}
