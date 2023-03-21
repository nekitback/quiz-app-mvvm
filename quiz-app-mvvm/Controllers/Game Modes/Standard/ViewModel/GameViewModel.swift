import Foundation

final class GameViewModel {
    let questionProvider: QuestionsProvider & QuestionsProviderImpl
    var zeroView = Bindable<ZeroView>(ZeroView.init(jsonName: "hourglass"))
    var questionSectionType = Bindable<[QuestionSectionType]>(QuestionSectionType.allCases)
    var questionType = Bindable<[QuestionType]>(QuestionType.allCases)
    var session = Bindable<Session>(Session())
    var currentQuestion = Bindable<Question?>(nil)
    var databaseManager = Bindable<DatabaseManager>(DatabaseManager())
    init(questionProvider: QuestionsProvider & QuestionsProviderImpl) {
        self.questionProvider = questionProvider
    }
}

extension GameViewModel {
    func fetchQuestions(completion: @escaping (Int, Int) -> Void) {
        let (_, number, count) = questionProvider.nextQuestion()
        completion(number, count)
    }
    
    func countCorrectQuestion() {
        var isCorrect = true
        let answers = questionProvider.currentQuestion?.answers ?? []
        for answer in answers {
            if answer.isCorrect != answer.isSelected {
                isCorrect = false
                if (questionProvider.currentQuestion?.id) != nil {
                    var ids = questionProvider.correctQuestionIds
                    let uncorrectId = questionProvider.currentQuestion?.id ?? 0
                    if let indexToRemove = ids.firstIndex(where: { $0 == uncorrectId }) {
                        ids.remove(at: indexToRemove)
                    }
                    questionProvider.correctQuestionIds = ids
                }
            }
        }
        if isCorrect == true {
            questionProvider.numberOfCorrectQuestions += 1
            session.value.userPoints += 1
            if (questionProvider.currentQuestion?.id) != nil {
                var ids = questionProvider.correctQuestionIds
                let correctId = questionProvider.currentQuestion?.id ?? 0
                ids.append(correctId)
                questionProvider.correctQuestionIds = Array(Set(ids))
            }
        }
    }
}

