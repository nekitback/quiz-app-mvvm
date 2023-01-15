import Foundation

final class Bindable<T> {
    
    typealias Listener = (T) -> Void
    private var listener: Listener?
    
    internal var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
