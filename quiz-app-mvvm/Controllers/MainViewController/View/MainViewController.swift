import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    var viewModel: MainViewModel? 
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.register(GameModeCell.self, forCellReuseIdentifier: GameModeCell.reuseId)
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseId)
        tableView.register(StartGameButtonCell.self, forCellReuseIdentifier: StartGameButtonCell.reuseId)
        return tableView
    }()
    
    private lazy var logoutBarButton: UIBarButtonItem = {
        let image = UIImage(systemName: MainViewConstants.logoutButtonImage)
        let button = UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(logoutBarButtonAction))
        return button
    }()
    
    private lazy var slideMenuBarButton: UIBarButtonItem = {
        let image = UIImage(systemName: MainViewConstants.slideButtonImage)
        let button = UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(slideMenuBarButtonAction))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bind()
    }
}

extension MainViewController {
    private func bind() {
        viewModel?.questionProvider.fetchAllQuestions {
            self.viewModel?.categories.value = self.viewModel?.questionProvider.fetchAllCategories() ?? [Category(name: "")]
            self.viewModel?.gameModes.value = self.viewModel?.questionProvider.fetchAllGameModes() ?? [GameMode(name: "")]
            self.tableView.reloadData()
        }
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        navigationItem.leftBarButtonItem = logoutBarButton
        navigationItem.rightBarButtonItem = slideMenuBarButton
        navigationController?.isNavigationBarHidden = true
        navigationItem.hidesBackButton = true
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.topMargin.equalToSuperview()
        }
    }
}

extension MainViewController {
    @objc
    func logoutBarButtonAction() {
        viewModel?.authManager.value.logout()
        
        let alertController = UIAlertController(title: "Хотите выйти?", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Остаться", style: .cancel)
        let okAction = UIAlertAction(title: "Выйти", style: .destructive) { _ in
            self.viewModel?.session.value.userNickname.removeAll()
            self.viewModel?.session.value.userEmail.removeAll()
            self.viewModel?.session.value.userPoints = 0
            //            self.questionProvider.correctQuestionIds.removeAll()
            //            UserDefaults.standard.removeObject(forKey: "Score")
            
            UIView.transition(with: UIWindow.key, duration: 0.5, options: .curveEaseOut) {
                UIWindow.key.rootViewController = AuthViewController()
            }
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc
    func slideMenuBarButtonAction() {
        
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.categorySections.value.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel else { return UITableViewCell() }
        let cellType = viewModel.categorySections.value[indexPath.section]
        switch cellType {
        case .gameMode:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GameModeCell.reuseId, for: indexPath) as? GameModeCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configure(viewModel.gameModes.value)
            return cell
        case .category:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseId, for: indexPath) as? CategoryCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configure(viewModel.categories.value)
            return cell
        case .startButton:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StartGameButtonCell.reuseId, for: indexPath) as? StartGameButtonCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configure(viewModel.currentCategory.value, viewModel.currentGameMode.value)
            return cell
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.init(name: "Avenir Next Bold", size: 20)
            header.textLabel?.textColor = .black
            header.textLabel?.numberOfLines = 0
            header.textLabel?.textAlignment = .center
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MainViewConstants.heightForHeader
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sectionType = CategorySectionType(rawValue: section) {
            switch sectionType {
            case .gameMode:
                return MainTitles.getModuleTitle(.gameMode)
            case .category:
                return MainTitles.getModuleTitle(.category)
            case .startButton:
                return MainTitles.getModuleTitle(.startButton)
            }
        }
        return MainTitles.getModuleTitle(.startButton)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MainViewConstants.heightForRow
    }
}

extension MainViewController: CategoryCellOutput {
    func categoryCellDidSelect(_ category: Category) {
        viewModel?.categoryCellDidSelect(category)
        viewModel?.questionProvider.fetchQuestion(by: category) { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension MainViewController: GameModeCellOutput {
    func gameModeCellDidSelect(_ gameMode: GameMode) {
        viewModel?.gameModeCellDidSelect(gameMode)
        tableView.reloadData()
    }
}

extension MainViewController: StartGameButtonCellOutput {
    func startGameButtonCellDidSelect() {
        let gameViewController = ModuleBuilder.assemblyGameViewController()
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }
}
