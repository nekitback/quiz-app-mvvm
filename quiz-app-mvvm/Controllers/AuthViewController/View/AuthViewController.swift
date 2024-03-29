import UIKit
import SnapKit

final class AuthViewController: UIViewController {
    
    var viewModel: AuthViewModel?
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: AuthViewConstants.backgroundImage)
        return imageView
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: AuthViewConstants.loginLabelFontSize, weight: .bold)
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "email"
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.backgroundColor = AuthViewConstants.textfieldBackgroundColor
        textField.font = AuthViewConstants.textfieldFont
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        return textField
    }()
    
    private let nicknameTextfield: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "nickname"
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.backgroundColor = AuthViewConstants.textfieldBackgroundColor
        textField.font = AuthViewConstants.textfieldFont
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = AuthViewConstants.textfieldBackgroundColor
        textField.font = AuthViewConstants.textfieldFont
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        return textField
    }()
    
    private lazy var entryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = AuthViewConstants.buttonBackgroundColor
        button.layer.borderWidth = AuthViewConstants.buttonBorderWidth
        button.layer.cornerRadius = AuthViewConstants.buttonCornerRadius
        button.setTitleShadowColor(.black, for: .normal)
        button.addTarget(self, action: #selector(entryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var entryTypeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(entryTypeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupViews()
        setupConstraints()
        bind()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension AuthViewController {
    private func bind() {
        viewModel?.authType.bind { [unowned self] in
            updateType(depends: $0)
        }
    }
    
    private func updateType(depends authType: AuthType?) {
        switch authType {
        case .login:
            loginLabel.text = AuthTitles.getModuleTitle(.authTitle)
            entryTypeButton.setTitle(AuthTitles.getModuleTitle(.registrationEntryTypeButtonTitle), for: .normal)
            entryButton.setTitle(AuthTitles.getModuleTitle(.authEntryButtonTitle), for: .normal)
            nicknameTextfield.isHidden = true
            passwordTextField.snp.removeConstraints()
            passwordTextField.snp.makeConstraints {
                $0.top.equalTo(emailTextField).inset(40)
                $0.left.right.equalToSuperview().inset(50)
            }
            
        case .registration:
            loginLabel.text = AuthTitles.getModuleTitle(.registrationTitle)
            entryTypeButton.setTitle(AuthTitles.getModuleTitle(.authEntryTypeButtonTitle), for: .normal)
            entryButton.setTitle(AuthTitles.getModuleTitle(.registrationEntryButtonTitle), for: .normal)
            nicknameTextfield.isHidden = false
            passwordTextField.snp.removeConstraints()
            passwordTextField.snp.makeConstraints {
                $0.top.equalTo(nicknameTextfield).inset(40)
                $0.left.right.equalToSuperview().inset(50)
            }
        default:
            break
        }
    }
    
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(loginLabel)
        view.addSubview(emailTextField)
        view.addSubview(nicknameTextfield)
        view.addSubview(passwordTextField)
        view.addSubview(entryButton)
        view.addSubview(entryTypeButton)
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField).inset(40)
            $0.left.right.equalToSuperview().inset(50)
        }
        
        loginLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp_topMargin).inset(100)
            $0.centerX.equalTo(view.snp_centerXWithinMargins)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(loginLabel).inset(60)
            $0.left.right.equalToSuperview().inset(50)
        }
        
        nicknameTextfield.snp.makeConstraints {
            $0.top.equalTo(emailTextField).inset(40)
            $0.left.right.equalToSuperview().inset(50)
        }
        
        entryButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField).inset(60)
            $0.left.right.equalToSuperview().inset(50)
        }
        
        entryTypeButton.snp.makeConstraints {
            $0.top.equalTo(entryButton).inset(60)
            $0.left.right.equalToSuperview().inset(50)
        }
    }
}

extension AuthViewController {
    @objc
    private func entryButtonTapped() {
        if viewModel?.authType.value == .login {
            authorization()
        }
        if viewModel?.authType.value == .registration {
            registration()
        }
    }
    
    @objc
    private func entryTypeButtonTapped() {
        if viewModel?.authType.value == .registration {
            viewModel?.authType.value = .login
        } else {
            viewModel?.authType.value = .registration
        }
    }
}

extension AuthViewController {
    private func showMainScreen() {
        let mainViewController = ModuleBuilder.assemblyMainViewController()
        UIView.transition(with: UIWindow.key, duration: 0.7, options: .curveEaseIn) {
            UIWindow.key.rootViewController = mainViewController
        }
    }
    
    private func authorization() {
        viewModel?.authManager.value.authorizeToFirebase(email: "\(emailTextField.text ?? "")", password: "\(passwordTextField.text ?? "")") { email, error in
            if self.emailTextField.text == email {
                self.viewModel?.databaseManager.value.fetchNickname(email: "\(self.emailTextField.text ?? "")") { nickname in
                    self.viewModel?.session.value.userNickname = nickname
                }
                self.viewModel?.session.value.userEmail = email ?? ""
                self.viewModel?.databaseManager.value.fetchPoints(email: "\(self.emailTextField.text ?? "")") { points in
                    self.viewModel?.session.value.userPoints = points
                }
            }
            if let error = error {
                let alertController = UIAlertController(title: "", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .cancel)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showMainScreen()
            }
        }
    }
    
    private func registration() {
        viewModel?.databaseManager.value.nicknameUsed(nickname: "\(nicknameTextfield.text ?? "")") { exists in
            if exists > 0 {
                self.nicknameTextfield.text = ""
                self.nicknameTextfield.placeholder = "этот никнейм уже занят"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.nicknameTextfield.placeholder = "nickname"
                }
            }
            if exists == 0 {
                self.viewModel?.authManager.value.registrationToFirebase(email: "\(self.emailTextField.text ?? "")", password: "\(self.passwordTextField.text ?? "")") { result, error in
                    if result != nil {
                        self.viewModel?.databaseManager.value.insertUser(with: QuizAppUser(uid: String(result?.user.uid ?? ""), email: self.emailTextField.text ?? "", nickname: self.nicknameTextfield.text ?? "", points: 0))
                        let alertController = UIAlertController(title: "", message: "Registration successful", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Ok", style: .cancel)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true) {
                            self.entryTypeButtonTapped()
                        }
                    }
                    if let error = error {
                        print(error.localizedDescription)
                        let alertController = UIAlertController(title: "", message: "\(error.localizedDescription)", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Ok", style: .cancel)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                        return
                    }
                }
            }
        }
    }
}
