import Foundation

final class AuthViewModel {
    var authType = Bindable<AuthType>(.login)
    var authManager = Bindable<AuthManager>(AuthManager())
    var databaseManager = Bindable<DatabaseManager>(DatabaseManager())
    var session = Bindable<Session>(Session())
}
