import UIKit
import SnapKit

class GameViewController: UIViewController {
    
    var viewModel: GameViewModel?
    
    lazy var questionNumberHeader = QuestionNumberHeader(frame: CGRect(x: .zero, y: .zero, width: UIScreen.main.bounds.width, height: 100))
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(QuestionImageCell.self, forCellReuseIdentifier: QuestionImageCell.reuseId)
        tableView.register(QuestionTextCell.self, forCellReuseIdentifier: QuestionTextCell.reuseId)
        tableView.register(AnswerCell.self, forCellReuseIdentifier: AnswerCell.reuseId)
        tableView.register(CheckButtonCell.self, forCellReuseIdentifier: CheckButtonCell.reuseId)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
        bind()
    }
}

extension GameViewController {
    private func bind() {
        viewModel?.fetchQuestions { number, count in
            self.questionNumberHeader.configure(currentQuestion: number, numberOfQuestions: count)
            self.tableView.reloadData()
        }
    }
    
    private func setupViews() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

extension GameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel else { return UIView() }
        let sectionType = viewModel.questionSectionType.value[section]
        switch sectionType {
        case .question:
            return questionNumberHeader
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let viewModel else { return 0 }
        let sectionType = viewModel.questionSectionType.value[section]
        switch sectionType {
        case .question:
            return UIScreen.height * 0.1
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.questionSectionType.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel else { return 0 }
        let sectionType = viewModel.questionSectionType.value[section]
        switch sectionType {
        case .question:
            return viewModel.questionType.value.count
        case .answer:
            return viewModel.questionProvider.currentQuestion?.answers.count ?? .zero
        case .button:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel else { return UITableViewCell() }
        let cellType = viewModel.questionSectionType.value[indexPath.section]
        switch cellType {
        case .question:
            let questionType = viewModel.questionType.value[indexPath.row]
            switch questionType {
            case .text:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTextCell.reuseId, for: indexPath) as? QuestionTextCell else { return UITableViewCell() }
                cell.configure(viewModel.questionProvider.currentQuestion)
                return cell
            case .image:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionImageCell.reuseId, for: indexPath) as? QuestionImageCell else { return UITableViewCell() }
                cell.configure(viewModel.questionProvider.currentQuestion)
                return cell
            }
        case .answer:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AnswerCell.reuseId, for: indexPath) as? AnswerCell else { return UITableViewCell() }
            let answer = viewModel.questionProvider.currentQuestion?.answers[indexPath.row]
            cell.configure(answer, buttonState: viewModel.questionProvider.checkButtonState, answerIsCorrect: viewModel.questionProvider.answerIsCorrect, canTapAnswer: viewModel.questionProvider.canTapAnswer)
            cell.delegate = self
            return cell
        case .button:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckButtonCell.reuseId, for: indexPath) as? CheckButtonCell else { return UITableViewCell() }
            cell.configure(viewModel.questionProvider.currentQuestion, answerIsChecked: viewModel.questionProvider.answerIsChecked)
            cell.delegate = self
            return cell
        }
    }
}

extension GameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let sectionType = QuestionSectionType.init(rawValue: indexPath.section) {
            switch sectionType {
            case .question:
                if let questionType = QuestionType(rawValue: indexPath.row) {
                    switch questionType {
                    case .text:
                        return viewModel?.questionProvider.currentQuestion?.text == "" ? 0 : UIScreen.height * 0.2
                    case .image:
                        return viewModel?.questionProvider.currentQuestion?.image == "" ? 0 : UIScreen.height * 0.25
                    }
                }
            default: return UITableView.automaticDimension
            }
        }
        return UITableView.automaticDimension
    }
}

extension GameViewController: AnswerCellDelegate {
    func answerCellSelectAnswer() {
        tableView.reloadData()
    }
}

extension GameViewController: CheckButtonCellDelegate {
    func countCorrectQuestion() {
        viewModel?.countCorrectQuestion()
    }
    
    func checkButtonCellNextQuestion(_ buttonState: CheckButtonState) {
        guard let viewModel = viewModel else { return }
        viewModel.questionProvider.checkButtonState = buttonState
        switch buttonState {
        case .normal: break
        case .check:
            countCorrectQuestion()
            tableView.reloadData()
        case .next:
            let (question, number, count) = viewModel.questionProvider.nextQuestion()
            questionNumberHeader.configure(currentQuestion: number, numberOfQuestions: count)
            if question == nil {
                let personalScreenViewController = ModuleBuilder.assemblyPersonalScoreViewController()
                viewModel.databaseManager.value.updatePoints(email: viewModel.session.value.userEmail, points: viewModel.session.value.userPoints)
                viewModel.questionProvider.numberOfCorrectQuestions = .zero
                UIView.transition(with: UIWindow.key, duration: 0.7, options: .curveEaseIn) {
                    UIWindow.key.rootViewController = personalScreenViewController
                }
            }
        }
        tableView.reloadData()
    }
}

