import UIKit
import Lottie
import SnapKit

class ZeroView: UIView {
    var animationView: LottieAnimationView!
    
    init(jsonName: String) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        setupAnimation(jsonName)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fatalError("init(coder:) has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupAnimation(_ jsonName: String) {
        let animation = LottieAnimation.named(jsonName)
        animationView = LottieAnimationView(animation: animation)
        self.addSubview(animationView)
        
        animationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        animationView.play()
        animationView.loopMode = .repeat(10)
    }
    
    func startAnimation() {
        animationView.play()
    }
    
    func stopAnimation() {
        animationView.stop()
    }
}
