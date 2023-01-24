import Foundation
import SwiftKeychainWrapper

final class Session {
    var userEmail: String {
        get {
            return KeychainWrapper.standard.string(forKey: "userEmail") ?? ""
        }
        set {
            KeychainWrapper.standard.set(newValue, forKey: "userEmail")
        }
    }
    
    var userNickname: String {
        get {
            UserDefaults.standard.string(forKey: "userNickname") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userNickname")
        }
    }
    
    var userPoints: Int {
        get {
            UserDefaults.standard.integer(forKey: "userPoints")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userPoints")
        }
    }
}
