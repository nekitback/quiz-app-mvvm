import UIKit
import SDWebImage

class QuestionImageCell: UITableViewCell {
    
    static var reuseId = "QuestionImageCell"
    
    private lazy var questionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
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
        contentView.addSubview(questionImageView)
    }
    
    private func setupConstraints() {
        questionImageView.snp.makeConstraints {
            $0.top.bottom.left.right.equalTo(contentView)
        }
    }
    //MARK: - Public
    func configure(_ model: Question?) {
        let url = URL.init(string: model?.image ?? "")
        questionImageView.sd_setImage(with: url)
    }
}
