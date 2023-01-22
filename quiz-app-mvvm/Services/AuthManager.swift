import Foundation
import FirebaseAuth

final class AuthManager {
    
    func authorizeToFirebase(email: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            completion(result?.user.email, error)
        }
    }
    
    func registrationToFirebase(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            completion(result, error)
        }
    }
    
    func logout() {
        
    }
}
