import UIKit

class QuestionNumberHeader: UIView {
    private let backgroundImageView: UIImageView = {
        let image = UIImage(named: "gameHeaderView")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var headerLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "Avenir Next Bold", size: 30)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private
    private func setupViews() {
        self.addSubview(backgroundImageView)
        self.addSubview(headerLabel)
        self.backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerLabel.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview().inset(30)
        }
    }
    
    //MARK: - Public
    func configure(currentQuestion: Int, numberOfQuestions: Int) {
        headerLabel.text = "Вопрос \(currentQuestion) из \(numberOfQuestions)"
    }
}
