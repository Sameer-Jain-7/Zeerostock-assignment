//
//  SignupViewController.swift
//  zeerostock
//
//  Created by Sameer Jain on 16/05/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class SignupViewController: UIViewController {
    
    private let viewModel = AuthViewModel()
    private let gradientLayer = CAGradientLayer()
    
    private let nameTextField = UITextField.createTextField(
        placeholder: "Enter Name"
    )
    
    private let emailTextField = UITextField.createTextField(
        placeholder: "Enter Email"
    )
    
    private let passwordTextField = UITextField.createTextField(
        placeholder: "Enter Password",
        isSecure: true
    )
    
    private let roleSegmentedControl: UISegmentedControl = {

        let control = UISegmentedControl(
            items: ["User", "Supplier"]
        )

        control.selectedSegmentIndex = 0

        control.backgroundColor = UIColor.white.withAlphaComponent(0.7)

        control.selectedSegmentTintColor = .black

        control.setTitleTextAttributes(
            [.foregroundColor: UIColor.white],
            for: .selected
        )

        control.setTitleTextAttributes(
            [.foregroundColor: UIColor.black],
            for: .normal
        )

        control.layer.cornerRadius = 12
        control.clipsToBounds = true

        control.translatesAutoresizingMaskIntoConstraints = false

        return control
    }()
    
    private let signupButton: UIButton = {

        let button = UIButton(type: .system)

        button.setTitle("Create Account", for: .normal)

        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)

        button.layer.cornerRadius = 16

        button.titleLabel?.font = .systemFont(
            ofSize: 18,
            weight: .semibold
        )

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 8)
        button.layer.shadowRadius = 12

        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    private let titleLabel: UILabel = {

        let label = UILabel()

        label.text = "Signup"
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private let subtitleLabel: UILabel = {

        let label = UILabel()

        label.text = "Welcome to ZeeroStock Assignment.\nCreate your Account"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private let toggleLabel: UILabel = {

        let label = UILabel()

        label.text = "Are you a User or a Supplier?"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {

        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor.systemIndigo.cgColor
        ]

        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds

        view.layer.addSublayer(gradientLayer)

        view.addSubview(containerView)

        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(nameTextField)
        containerView.addSubview(emailTextField)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(toggleLabel)
        containerView.addSubview(roleSegmentedControl)
        containerView.addSubview(signupButton)

        signupButton.addTarget(
            self,
            action: #selector(signupTapped),
            for: .touchUpInside
        )

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

            nameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            nameTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 56),

            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 18),
            emailTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 56),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 18),
            passwordTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 56),
            
            toggleLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            toggleLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor, constant: 10),
            toggleLabel.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),

            roleSegmentedControl.topAnchor.constraint(equalTo: toggleLabel.bottomAnchor, constant: 10),
            roleSegmentedControl.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            roleSegmentedControl.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            roleSegmentedControl.heightAnchor.constraint(equalToConstant: 45),

            signupButton.topAnchor.constraint(equalTo: roleSegmentedControl.bottomAnchor, constant: 30),
            signupButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            signupButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            signupButton.heightAnchor.constraint(equalToConstant: 56),
            signupButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30)
        ])
    }
    
    @objc private func signupTapped() {
        
        guard validateDetails() else {
            showAlert(message: "Please enter all the details.")
            return
        }
        
        let role = roleSegmentedControl.selectedSegmentIndex == 0
        ? "user"
        : "supplier"
        
        showLoading()
        
        viewModel.signup(
            name: nameTextField.text ?? "",
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? "",
            role: role
        ) { [weak self] result in
            
            DispatchQueue.main.async {
                
                switch result {
                case .success:

                    guard let userId = Auth.auth().currentUser?.uid else {
                        self?.hideLoading()
                        self?.showAlert(message: "Unable to fetch user")
                        return
                    }

                    Firestore.firestore()
                        .collection("users")
                        .document(userId)
                        .getDocument { snapshot, error in

                            guard let data = snapshot?.data(),
                                  let role = data["role"] as? String else {
                                self?.hideLoading()
                                self?.showAlert(message: "Unable to fetch user role")
                                return
                            }
                            RoleManager.shared.currentRole = role
                            self?.hideLoading()
                            DispatchQueue.main.async {

                                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {

                                    switch role {

                                    case "user":
                                        sceneDelegate.window?.rootViewController = UserTabBarController()

                                    case "supplier":
                                        sceneDelegate.window?.rootViewController = SupplierTabBarController()

                                    case "super_admin", "product_admin", "auction_admin":
                                        sceneDelegate.window?.rootViewController = AdminTabBarController()

                                    default:
                                        break
                                    }
                                }
                            }
                        }
                    
                case .failure(let error):
                    self?.hideLoading()
                    if let errorCode = AuthErrorCode(rawValue: error._code) {

                        switch errorCode {

                        case .wrongPassword:
                            self?.showAlert(message: "Wrong password".localiz())

                        case .invalidEmail:
                            self?.showAlert(message: "Invalid email".localiz())

                        case .userNotFound:
                            self?.showAlert(message: "User not found".localiz())

                        default:
                            self?.showAlert(message: error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func validateDetails() -> Bool {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return !email.isEmpty && !password.isEmpty && !name.isEmpty
    }
}
