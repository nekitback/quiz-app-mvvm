import UIKit

protocol StartGameButtonCellOutput: AnyObject {
    func startGameButtonCellDidSelect()
}

class StartGameButtonCell: UITableViewCell {
    
    static var reuseId = "StartGameButtonCell"
    
    weak var delegate: StartGameButtonCellOutput?
    
    private lazy var startButton: UIButton = {
        var button = UIButton()
        button.setTitle("Начать", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "Avenir Next Bold", size: 20)
        button.addTarget(self, action: #selector(startGameAction), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private
    
    private func setupViews() {
        contentView.addSubview(startButton)
        self.selectionStyle = .none
    }
    
    private func setupConstraints() {
        startButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(30)
            $0.top.bottom.equalToSuperview().inset(20)
        }
    }
    
    //MARK: - Public
    func configure(_ model: Category?, _ gameModeModel: GameMode?) {
        if model?.selected == true && gameModeModel?.selected == true {
            startButton.isEnabled = true
        } else {
            startButton.isEnabled = false
        }
    }
    
    //MARK: - Actions
    @objc
    func startGameAction() {
        delegate?.startGameButtonCellDidSelect()
    }
}

