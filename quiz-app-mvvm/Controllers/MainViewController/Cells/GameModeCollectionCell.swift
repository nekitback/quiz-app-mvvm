import UIKit

protocol GameModeCollectionCellOutput: AnyObject {
    func gameModeCollectionCellDidSelect(_ gameMode: GameMode)
}

class GameModeCollectionCell: UICollectionViewCell {
    
    static var reuseId = "GameModeCollectionCell"
    
    weak var delegate: GameModeCollectionCellOutput?
    
    var gameMode: GameMode?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Avenir Next", size: 20)
        label.textColor = .systemBackground
        return label
    }()
    
    var imageLabel: UILabel = {
       let label = UILabel()
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 40)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var titleButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(titleButtonAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public
    func configure(model: GameMode) {
        switch model.name {
        case "Быстрая игра":
            titleButton.isUserInteractionEnabled = false
            imageLabel.text = "🚫"
        case "Стандартная игра":
            titleButton.isUserInteractionEnabled = true
            imageLabel.text = ""
        default: return
        }
        
        self.gameMode = model
        titleLabel.text = model.name
        
        if model.selected {
            titleLabel.backgroundColor = .systemGreen
        } else {
            titleLabel.backgroundColor = .systemBlue
        }
    }
    
    // MARK: - Private
    
    private func setupViews() {
        titleLabel.backgroundColor = .blue
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageLabel)
        contentView.addSubview(titleButton)
    }
    
    private func setupConstraints() {
        
        titleButton.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(contentView).inset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(contentView).inset(20)
        }
        
        imageLabel.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.left)
        }
    }
    
    // MARK: - Actions
    
    @objc
    func titleButtonAction() {
        if let gameMode = gameMode {
            gameMode.selected = true
            delegate?.gameModeCollectionCellDidSelect(gameMode)
        }
    }
}
