import UIKit

protocol CheckButtonCellDelegate: AnyObject {
    func checkButtonCellNextQuestion(_ buttonState: CheckButtonState)
}

class CheckButtonCell: UITableViewCell {
    
    static var reuseId = "CheckButtonCell"
    
    var buttonState: CheckButtonState = .normal
    
    var delegate: CheckButtonCellDelegate?
    
    private lazy var checkButton: UIButton = {
        var button = UIButton()
        button.setTitle("Проверить", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "Avenir Next Bold", size: 20)
        button.addTarget(self, action: #selector(nextQuestionAction), for: .touchUpInside)
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
        contentView.addSubview(checkButton)
        self.selectionStyle = .none
    }
    
    private func setupConstraints() {
        checkButton.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(50)
        }
    }
    
    //MARK: - Public
    func configure(_ model: Question?, answerIsChecked: (value: Bool, count: Int)) {
        checkButton.isEnabled = answerIsChecked.value
    }
    
    //MARK: - Actions
    @objc
    func nextQuestionAction() {
        switch buttonState {
        case .normal:
            checkButton.setTitle("Следующий", for: .normal)
            buttonState = .check
            delegate?.checkButtonCellNextQuestion(buttonState)
        case .check:
            checkButton.setTitle("Проверить", for: .normal)
            buttonState = .next
            delegate?.checkButtonCellNextQuestion(buttonState)
        case .next:
            checkButton.setTitle("Следующий", for: .normal)
            buttonState = .check
            delegate?.checkButtonCellNextQuestion(buttonState)
        }
    }
}

