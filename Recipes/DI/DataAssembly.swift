import Swinject

final class DataAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ErrorHandler.self) { (r) -> ErrorHandler in
            let tabbarController = r.resolve(UITabBarController.self)!
            let errorHandler = ErrorHandler(tabbarController: tabbarController)
            return errorHandler
        }
        container.autoregister(RecipeServiceProtocol.self, initializer: RecipeService.init)
    }
}
