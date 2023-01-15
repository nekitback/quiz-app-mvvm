import UIKit
import SnapKit

final class AuthViewController: UIViewController {
    
    internal var viewModel: AuthViewModel?
    
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
            loginLabel.text = ModuleTitles.getModuleTitle(.authTitle)
            entryTypeButton.setTitle(ModuleTitles.getModuleTitle(.registrationEntryTypeButtonTitle), for: .normal)
            entryButton.setTitle(ModuleTitles.getModuleTitle(.authEntryButtonTitle), for: .normal)
            nicknameTextfield.isHidden = true
            passwordTextField.snp.removeConstraints()
            passwordTextField.snp.makeConstraints {
                $0.top.equalTo(emailTextField).inset(40)
                $0.left.right.equalToSuperview().inset(50)
            }
            
        case .registration:
            loginLabel.text = ModuleTitles.getModuleTitle(.registrationTitle)
            entryTypeButton.setTitle(ModuleTitles.getModuleTitle(.authEntryTypeButtonTitle), for: .normal)
            entryButton.setTitle(ModuleTitles.getModuleTitle(.registrationEntryButtonTitle), for: .normal)
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
        view.backgroundColor = .systemBlue
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

