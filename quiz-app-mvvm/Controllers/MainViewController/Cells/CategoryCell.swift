import UIKit

protocol CategoryCellOutput: AnyObject {
    func categoryCellDidSelect(_ category: Category)
}

class CategoryCell: UITableViewCell {
    static var reuseId = "CategoryCell"
    
    weak var delegate: CategoryCellOutput?
    
    var categories: [Category] = [] {
        didSet {
            categoryCollectionView.reloadData()
        }
    }
    
    lazy var categoryCollectionView: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let paddingSize = Layout.paddingCount * Layout.padding
        let cellSize = (UIScreen.width - paddingSize) / Layout.itemsCount
        layout.itemSize = CGSize(width: 200, height: cellSize)
        layout.minimumLineSpacing = Layout.padding
        layout.minimumInteritemSpacing = Layout.padding 
        layout.sectionInset = UIEdgeInsets(top: Layout.padding, left: Layout.padding, bottom: Layout.padding, right: Layout.padding)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CategoryCollectionCell.self, forCellWithReuseIdentifier: CategoryCollectionCell.reuseId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func configure(_ categories: [Category]) {
        self.categories = categories
    }
    
    // MARK: - Private
    
    private func setupViews() {
        contentView.addSubview(categoryCollectionView)
    }
    
    private func setupConstraints() {
        categoryCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension CategoryCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.reuseId, for: indexPath) as? CategoryCollectionCell else { return UICollectionViewCell() }
        
        let category = categories[indexPath.section]
        
        cell.configure(model: category)
        cell.delegate = self
        
        return cell
        
    }
}

extension CategoryCell {
    struct Layout {
        static let itemsCount: CGFloat = 3
        static let padding: CGFloat = 20
        static let paddingCount: CGFloat = itemsCount + 1
    }
}

extension CategoryCell: CategoryCollectionCellOutput {
    func categoryCollectionCellDidSelect(_ category: Category) {
        delegate?.categoryCellDidSelect(category)
    }
}

