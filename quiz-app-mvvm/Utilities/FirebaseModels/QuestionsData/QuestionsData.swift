import Foundation

// MARK: - QuestionsResponse
struct QuestionsResponse: Codable {
    let items: [Question]
}

// MARK: - Item
struct Question: Codable {
    let id: Int
    let text, image: String?
    let type: String
    let category: String
    let answers: [Answer]
}

// MARK: - Answer
struct Answer: Codable {
    let id: Int
    let text: String
    let isCorrect: Bool
    var isSelected: Bool
}
