import UIKit

final class ModuleBuilder {
    static func assemblyAuthViewController() -> UIViewController {
        let authViewController = AuthViewController()
        let viewModel = AuthViewModel()
        authViewController.viewModel = viewModel
        return authViewController
    }
}
