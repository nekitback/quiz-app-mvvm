import Foundation
import FirebaseDatabase

protocol QuestionsProvider {
    
    var allQuestions: [Question] { get set }
    var questions: [Question] { get set }
    var activeQuestions: [Question] { get set }
    
    var correctQuestionIds: Array<Int> { get set }
    
    var checkButtonState: AnswerButtonState { get set }
    
    var currentQuestion: Question? { get set }
    
    var answerIsChecked: (Bool, Int) { get }
    var answerIsCorrect: Bool { get }
    var canTapAnswer: Bool { get }
    
    var numberOfCorrectQuestions: Int { get set }
    
    func nextQuestion() -> (Question?, Int, Int)
    
    func shuffleQuestions()
}

protocol QuestionProviderFetchProtocol: AnyObject {
    func fetchAllLocalQuestions()
    func fetchAllQuestions(completion: @escaping () -> Void)
}

final class QuestionsProviderImpl: QuestionsProvider, QuestionProviderFetchProtocol {
    var allQuestions: [Question] = []
    var questions: [Question] = []
    var activeQuestions: [Question] = []
    
    var correctQuestionIds: [Int] {
        get {
            let array = UserDefaults.standard.array(forKey: "correctQuestionIds") as? [Int] ?? []
            return array
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "correctQuestionIds")
        }
    }
    
    var currentQuestion: Question? = nil
    var checkButtonState: AnswerButtonState = .normal
    
    var numberOfCorrectQuestions = 0
    
    var canTapAnswer: Bool {
        let (_, selectedCount) = answerIsChecked
        let type = currentQuestion?.type ?? ""
        print(type.contains("single"))
        if selectedCount >= 1,  type.contains("single") || type.contains("binary") {
            return false
        }
        return true
    }
    
    var answerIsCorrect: Bool {
        let answers = currentQuestion?.answers ?? []
        for answer in answers {
            if answer.isCorrect != answer.isSelected {
                return false
            }
        }
        return true
    }
    
    var answerIsChecked: (Bool, Int) {
        var selectedCount = 0
        var isSelected = false
        let answers = currentQuestion?.answers ?? []
        for answer in answers {
            if answer.isSelected == true {
                isSelected = true
                selectedCount += 1
            }
        }
        return (isSelected, selectedCount)
    }
    
    func fetchAllLocalQuestions() { }
    
    func fetchQuestion(by category: Category, completion: @escaping ()->()) {
        
        questions = allQuestions.filter { $0.category == category.name }
        activeQuestions = questions
        
        completion()
    }
    
    func fetchAllCategories() -> [Category] {
        var categories: Set<String> = []
        for question in allQuestions {
            categories.insert(question.category)
        }
        
        let result = categories.sorted().map { Category(name: $0) }
        
        return result
    }
    
    func fetchAllGameModes() -> [GameMode] {
        var gameModes: Set<String> = []
        let modes = ["Быстрая игра", "Стандартная игра"]
        
        for mode in modes {
            gameModes.insert(mode)
        }
        
        let sortedGameModes = gameModes.sorted()
        
        var result: [GameMode] = []
        
        for gameModeName in sortedGameModes {
            let object = GameMode.init(name: gameModeName)
            result .append(object)
        }
        return result
    }
    
    func fetchAllQuestions(completion: @escaping ()->()) {
        
        let ref = Database.database().reference()
        
        ref.child("items").observe(.value) { snapshot in
            guard let children = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            let objects: [Question] = children.compactMap { snapshot in
                return try? JSONDecoder().decode(Question.self, from: snapshot.data!)
            }
            
            self.allQuestions = objects
            self.questions = objects
            completion()
        }
        
    }
    
    func nextQuestion() -> (Question?, Int, Int) {
        
        currentQuestion = activeQuestions.first
        self.activeQuestions = Array(activeQuestions.dropFirst())
        
        return (currentQuestion, questions.count - activeQuestions.count, questions.count)
    }
    
    func shuffleQuestions() {
        allQuestions.shuffle()
    }
}
