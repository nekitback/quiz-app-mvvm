import Foundation

final class MainViewModel {
    let questionProvider: QuestionsProvider & QuestionProviderFetchProtocol & QuestionsProviderImpl
    var authManager = Bindable<AuthManager>(AuthManager())
    var session = Bindable<Session>(Session())
    var categories = Bindable<[Category]>([])
    var gameModes = Bindable<[GameMode]>([])
    var currentCategory = Bindable<Category>(Category(name: ""))
    var currentGameMode = Bindable<GameMode>(GameMode(name: ""))
    var categorySections = Bindable<[CategorySectionType]>(CategorySectionType.allCases)
    var zeroView = Bindable<ZeroView>(ZeroView.init(jsonName: "hourglass"))
    init(qeustionProvider: QuestionsProvider & QuestionProviderFetchProtocol & QuestionsProviderImpl) {
        self.questionProvider = qeustionProvider
    }
}

extension MainViewModel: CategoryCellOutput {
    func categoryCellDidSelect(_ category: Category) {
        currentCategory.value = category
        categories.value.forEach {
            if $0.name == category.name {
                $0.selected = true
            } else {
                $0.selected = false
            }
        }
    }
}

extension MainViewModel: GameModeCellOutput {
    func gameModeCellDidSelect(_ gameMode: GameMode) {
        currentGameMode.value = gameMode
        gameModes.value.forEach {
            if $0.name == gameMode.name {
                $0.selected = true
            } else {
                $0.selected = false
            }
        }
    }
}

