import Swinject

final class ScreenAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(HomeViewController.self, initializer: HomeViewController.init)
        container.autoregister(UITabBarController.self, initializer: UITabBarController.init(nibName:bundle:))
            .inObjectScope(.weak)
    }
}
