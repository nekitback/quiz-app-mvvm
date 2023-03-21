import UIKit

class QuestionTextCell: UITableViewCell {
    
    static var reuseId = "QuestionTextCell"
    
    private lazy var backgroundCellView: UIView = {
        var view = UIView()
        view.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Avenir Next", size: 20)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func setupViews() {
        contentView.addSubview(backgroundCellView)
        contentView.addSubview(titleLabel)
    }
    private func setupConstraints() {
        backgroundCellView.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(contentView).inset(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(backgroundCellView).inset(20)
        }
    }
    
    // MARK: - Public
    func configure(_ model: Question?) {
        titleLabel.text = model?.text ?? ""
    }
}
