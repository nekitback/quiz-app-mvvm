import Foundation
import FirebaseDatabase

final class DatabaseManager {
    private let database = Database.database().reference()
}

extension DatabaseManager {
    func insertUser(with user: QuizAppUser) {
        var safeEmail = user.email ?? ""
        safeEmail = safeEmail.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child("users/\(safeEmail)").setValue([
            "uid": user.uid,
            "nickname": user.nickname,
            "points": user.points
        ])
    }
    
    func nicknameUsed(nickname: String, completion: @escaping (Int) -> Void) {
        var nicknameCount: Int = .zero
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let children = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            let objects: [QuizAppUser] = children.compactMap { snapshot in
                return try? JSONDecoder().decode(QuizAppUser.self, from: snapshot.data!)
            }
            for object in objects {
                if object.nickname == nickname {
                    nicknameCount += 1
                }
            }
            completion(nicknameCount)
        }
    }
    
    func fetchPoints(email: String, completion: @escaping (Int) -> Void) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child("users/\(safeEmail)/points").observeSingleEvent(of: .value) { data in
            let points = data.value as? Int
            completion(points ?? 0)
        }
    }
    
    func fetchNickname(email: String, completion: @escaping (String) -> ()) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child("users/\(safeEmail)/nickname").observeSingleEvent(of: .value) { data in
            let nick = data.value as? String
            completion(nick ?? "")
        }
    }
    
    public func updatePoints(email: String, points: Int) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child("users/\(safeEmail)/points").setValue(points)
    }
}
