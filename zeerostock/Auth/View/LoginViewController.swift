import UIKit
import FirebaseAuth
import FirebaseFirestore

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = AuthViewModel()
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
//        label.font = .boldSystemFont(ofSize: 16)
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField = UITextField.createTextField(
        placeholder: "Enter Email"
    )
    
    private let passwordTextField = UITextField.createTextField(
        placeholder: "Enter Password",
        isSecure: true
    )
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 8)
        button.layer.shadowRadius = 12
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account? Signup →", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let containerView: UIView = {

        let view = UIView()

        view.backgroundColor = UIColor.white.withAlphaComponent(0.28)

        view.layer.cornerRadius = 28
        view.clipsToBounds = true

        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.12
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowRadius = 25

        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)

        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.cornerRadius = 28
        blurView.clipsToBounds = true

        view.insertSubview(blurView, at: 0)

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private let subtitleLabel: UILabel = {

        let label = UILabel()

        label.text = "Welcome back to ZeeroStock Assignment"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor.systemIndigo.cgColor
        ]

        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds

        view.layer.addSublayer(gradientLayer)
        
//        view.addSubview(titleLabel)
        view.addSubview(containerView)

        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(emailTextField)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(loginButton)
        containerView.addSubview(signupButton)
        
        emailTextField.autocapitalizationType = .none
        emailTextField.keyboardType = .emailAddress
        
        NSLayoutConstraint.activate([

            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 36),
            emailTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 56),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 56),

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32),
            loginButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 56),

            signupButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            signupButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            signupButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30)
        ])
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func loginTapped() {

        guard validateDetails() else {
            showAlert(message: "Please enter both email and password.")
            return
        }
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        UIView.animate(withDuration: 0.1) {
            self.loginButton.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.loginButton.transform = .identity
            }
        }

        print("========== LOGIN REQUEST ==========")
        print("Email:", email)
        print("Password:", password)
        print("===================================")
        showLoading()
        viewModel.login(email: email, password: password) { [weak self] result in

            DispatchQueue.main.async {

                switch result {

                case .success:
                    
                    guard let userId = Auth.auth().currentUser?.uid else {
                        self?.hideLoading()
                        return
                    }
                    
                    Firestore.firestore()
                        .collection("users")
                        .document(userId)
                        .getDocument { [weak self] snapshot, error in
                            
                            guard let data = snapshot?.data(),
                                  let role = data["role"] as? String else {
                                try? Auth.auth().signOut()
                                self?.hideLoading()
                                self?.showAlert(
                                    title: "Login Failed",
                                    message: "Invalid email or password"
                                )

                                return
                            }
                            RoleManager.shared.currentRole = role
                            self?.hideLoading()
                            DispatchQueue.main.async {
                                
                                if role == "user" {
                                    
                                    let vc = UserTabBarController()
                                    
                                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                                        sceneDelegate.window?.rootViewController = vc
                                    }
                                    
                                } else if role == "supplier" {
                                    
                                    let vc = SupplierTabBarController()
                                    
                                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                                        sceneDelegate.window?.rootViewController = vc
                                    }
                                } else if role == "super_admin" || role == "product_admin" || role == "auction_admin" {
                                    let vc = AdminTabBarController()
                                    
                                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                                        sceneDelegate.window?.rootViewController = vc
                                    }
                                }
                            }
                        }

                case .failure(let error):
                    self?.hideLoading()
                    print("========== LOGIN ERROR ==========")
                    print("Error:", error.localizedDescription)
                    print("Error Code:", error._code)

                    if let nsError = error as NSError? {
                        print("Full Error:", nsError)
                        print("UserInfo:", nsError.userInfo)
                    }

                    print("=================================")

                    if let errorCode = AuthErrorCode(rawValue: error._code) {

                        switch errorCode {

                        case .wrongPassword:
                            self?.showAlert(message: "Wrong password".localiz())

                        case .invalidEmail:
                            self?.showAlert(message: "Invalid email".localiz())

                        case .userNotFound:
                            self?.showAlert(message: "User not found".localiz())

                        case .invalidCredential:
                            self?.showAlert(title: "Invalid credentials".localiz(), message: "Enter Correct email/password".localiz())

                        default:
                            self?.showAlert(message: error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    @objc private func signupTapped() {
        navigationController?.pushViewController(SignupViewController(), animated: true)
    }
    
    func validateDetails() -> Bool {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return !email.isEmpty && !password.isEmpty
    }
}
