import UIKit

final class ModuleBuilder {
    static func assemblyAuthViewController() -> UIViewController {
        let authViewController = AuthViewController()
        let viewModel = AuthViewModel()
        authViewController.viewModel = viewModel
        return authViewController
    }
    
    static func assemblyMainViewController() -> UINavigationController {
        let mainViewController = MainViewController()
        let viewModel = MainViewModel(qeustionProvider: QuestionsProviderImpl())
        mainViewController.viewModel = viewModel
        let navigationController = UINavigationController(rootViewController: mainViewController)
        return navigationController
    }
    
    static func assemblyGameViewController() -> UIViewController {
        let gameViewController = GameViewController()
        let viewModel = GameViewModel()
        gameViewController.viewModel = viewModel
        return gameViewController
    }
}
