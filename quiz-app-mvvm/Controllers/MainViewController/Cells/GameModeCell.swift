import UIKit

protocol GameModeCellOutput: AnyObject {
    func gameModeCellDidSelect(_ gameMode: GameMode)
}

class GameModeCell: UITableViewCell {

    static var reuseId = "GameModeCell"
    
    weak var delegate: GameModeCellOutput?
    
    var gameModes: [GameMode] = [] {
        didSet {
            gameModeCollectionView.reloadData()
        }
    }
    
    lazy var gameModeCollectionView: UICollectionView = {
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
        collectionView.register(GameModeCollectionCell.self, forCellWithReuseIdentifier: GameModeCollectionCell.reuseId)
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
    func configure(_ model: [GameMode]) {
        self.gameModes = model
    }

    
    // MARK: - Private
    
    private func setupViews() {
        contentView.addSubview(gameModeCollectionView)
    }
    
    private func setupConstraints() {
        gameModeCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension GameModeCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return gameModes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameModeCollectionCell.reuseId, for: indexPath) as? GameModeCollectionCell else { return UICollectionViewCell() }
        let gameMode = gameModes[indexPath.section]
        cell.configure(model: gameMode)
        cell.delegate = self
        return cell
    }
}

extension GameModeCell {
    struct Layout {
        static let itemsCount: CGFloat = 3
        static let padding: CGFloat = 20
        static let paddingCount: CGFloat = itemsCount + 1
    }
}

extension GameModeCell: GameModeCollectionCellOutput {
    func gameModeCollectionCellDidSelect(_ gameMode: GameMode) {
        delegate?.gameModeCellDidSelect(gameMode)
    }
}
