import UIKit

protocol CategoryCollectionCellOutput: AnyObject {
    func categoryCollectionCellDidSelect(_ category: Category)
}

class CategoryCollectionCell: UICollectionViewCell {
    
    static var reuseId = "CategoryTextCollectionCell"
    
    weak var delegate: CategoryCollectionCellOutput?
    
    var category: Category?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Avenir Next", size: 20)
        label.textColor = .systemBackground
        label.backgroundColor = .blue
        return label
    }()
    
    var imageLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 50)
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
    func configure(model: Category) {
        
        switch model.name {
        case "Животные": imageLabel.text = "🐶"
        case "Космос": imageLabel.text = "🌓"
        case "Страны": imageLabel.text = "🌎"
        case "Спорт": imageLabel.text = "⚽️"
        default: return imageLabel.text = ""
        }
        
        self.category = model
        titleLabel.text = model.name
        
        if model.selected {
            titleLabel.backgroundColor = .systemGreen
        } else {
            titleLabel.backgroundColor = .systemBlue
        }
    }
    
    // MARK: - Private
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageLabel)
        contentView.addSubview(titleButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(contentView).inset(20)
        }
        
        imageLabel.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.left)
        }
        
        titleButton.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(contentView).inset(20)
        }
    }
    
    // MARK: - Actions
    @objc
    func titleButtonAction() {
        if let category = category {
            category.selected = true
            delegate?.categoryCollectionCellDidSelect(category)
        }
    }
}
