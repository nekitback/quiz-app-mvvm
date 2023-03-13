import Foundation

enum AuthTitles {
    case authTitle
    case registrationTitle
    case authEntryTypeButtonTitle
    case registrationEntryTypeButtonTitle
    case authEntryButtonTitle
    case registrationEntryButtonTitle
    private var title: String? {
        switch self {
        case .authTitle:
            return "Авторизация"
        case .registrationTitle:
            return "Регистрация"
        case .authEntryTypeButtonTitle:
            return "Уже есть аккаунт"
        case .registrationEntryTypeButtonTitle:
            return "Зарегистрироваться"
        case .authEntryButtonTitle:
            return "Войти"
        case .registrationEntryButtonTitle:
            return "Зарегистрироваться"
        }
    }
    
    static func getModuleTitle(_ moduleTitle: AuthTitles) -> String? {
        return moduleTitle.title
    }
}
