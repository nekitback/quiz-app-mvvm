import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureFirebase()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = ModuleBuilder.assemblyAuthViewController()
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        
        return true
    }
    
    func configureFirebase() {
        FirebaseApp.configure()
    }
}

