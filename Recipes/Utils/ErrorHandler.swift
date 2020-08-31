//
//  ErrorHandler.swift
//  Recipes
//
//  Created by Marcell Magyar on 2020. 09. 23..
//  Copyright © 2020. Marcell Magyar. All rights reserved.
//
import RxSwift

final class ErrorHandler {
    let tabbarController: UITabBarController

    var errorStack: [NetworkError] = []
    private var isCurrentlyShowingError = false

    init(tabbarController: UITabBarController) {
        self.tabbarController = tabbarController
    }

    func showErrorAlert(with message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        alert.addAction(action)
        tabbarController.present(alert, animated: true, completion: nil)
    }

    func showNewError(_ error: NetworkError) {
        errorStack.append(error)
        showErrorToast()
    }

    private func showErrorToast() {
        guard let currentError = errorStack.first, !isCurrentlyShowingError, let window = tabbarController.view.window else {
            return
        }

        let errorMessage = currentError.localizedDescription
        let errorToast = ErrorToast(errorMessage: errorMessage, topWindow: window, completion: dismissOldAndShowNewError)

        isCurrentlyShowingError = true
        errorToast.show()
    }

    private func dismissOldAndShowNewError() {
        self.errorStack.removeFirst()
        isCurrentlyShowingError = false
        showErrorToast()
    }
}

extension PrimitiveSequence {
    func showErrorAlert(with handler: ErrorHandler) -> RxSwift.PrimitiveSequence<Trait, Element> {
        return catchError { error in
            if let customError = error as? NetworkError {
                handler.showNewError(customError)
            } else {
                handler.showErrorAlert(with: error.localizedDescription)
            }
            throw error
        }
    }
}
