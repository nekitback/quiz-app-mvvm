import Foundation

struct UserResponse: Codable {
    let items: [QuizAppUser]
}

struct QuizAppUser: Codable {
    let uid: String
    let email: String?
    let nickname: String
    let points: Int
}
