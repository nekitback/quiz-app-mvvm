import Foundation

enum MainTitles {
    case gameMode
    case category
    case startButton
    private var title: String? {
        switch self {
        case .gameMode:
            return "Режим игры"
        case .category:
            return "Категории"
        case .startButton:
            return ""
        }
    }
    
    static func getModuleTitle(_ moduleTitle: MainTitles) -> String? {
        return moduleTitle.title
    }
}
