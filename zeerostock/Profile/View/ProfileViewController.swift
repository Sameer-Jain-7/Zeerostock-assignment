//
//  ProfileViewController.swift
//  zeerostock
//
//  Created by Sameer Jain on 16/05/26.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - UI Components
    private let viewModel = ProfileViewModel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .systemIndigo
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let roleBadgeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .systemIndigo
        label.layer.cornerRadius = 14
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        view.layer.shadowRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let auctionTitleLabel: UILabel = {

        let label = UILabel()
        label.text = "Auction Activity"
        label.font = .systemFont(
            ofSize: 20,
            weight: .bold
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let auctionStatsStackView: UIStackView = {

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let auctionCardView: UIView = {

        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        view.layer.shadowRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let accountInfoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Account Information"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ordersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View Orders", for: .normal)
        button.setImage(
            UIImage(systemName: "bag.fill"),
            for: .normal
        )
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 20
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.shadowColor = UIColor.systemIndigo.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowOffset = CGSize(width: 0, height: 8)
        button.layer.shadowRadius = 16
        button.semanticContentAttribute = .forceRightToLeft
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 18
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.shadowColor = UIColor.systemRed.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowOffset = CGSize(width: 0, height: 8)
        button.layer.shadowRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupData()

        if viewModel.isUser {
            viewModel.fetchAuctionActivity()
        }
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        
        title = "Profile"
        
        view.backgroundColor = UIColor.systemGray6
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(roleBadgeLabel)
        contentView.addSubview(infoCardView)
        contentView.addSubview(logoutButton)
        
        infoCardView.addSubview(accountInfoTitleLabel)
        infoCardView.addSubview(statsStackView)
        
        let accountTypeView = createInfoView(
            title: "Account Type",
            value: RoleManager.shared.currentRole.capitalized
        )
        
        let statusView = createInfoView(
            title: "Status",
            value: "Active"
        )
        
        statsStackView.addArrangedSubview(accountTypeView)
        statsStackView.addArrangedSubview(statusView)
        let wonAuctionView = createInfoView(
            title: "Won",
            value: "0"
        )

        wonAuctionView.tag = 2001

        let liveAuctionView = createInfoView(
            title: "Leading",
            value: "0"
        )

        liveAuctionView.tag = 2002

        auctionStatsStackView.addArrangedSubview(
            wonAuctionView
        )

        auctionStatsStackView.addArrangedSubview(
            liveAuctionView
        )
        ordersButton.addTarget(
            self,
            action: #selector(openOrders),
            for: .touchUpInside
        )
        logoutButton.addTarget(
            self,
            action: #selector(logoutTapped),
            for: .touchUpInside
        )
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 24),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 18),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            roleBadgeLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 18),
            roleBadgeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            roleBadgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
            roleBadgeLabel.heightAnchor.constraint(equalToConstant: 36),
            
            infoCardView.topAnchor.constraint(equalTo: roleBadgeLabel.bottomAnchor, constant: 24),
            infoCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            accountInfoTitleLabel.topAnchor.constraint(equalTo: infoCardView.topAnchor, constant: 24),
            accountInfoTitleLabel.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 20),
            accountInfoTitleLabel.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -20),
            
            statsStackView.topAnchor.constraint(equalTo: accountInfoTitleLabel.bottomAnchor, constant: 18),
            statsStackView.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -20),
            statsStackView.bottomAnchor.constraint(equalTo: infoCardView.bottomAnchor, constant: -24),
            statsStackView.heightAnchor.constraint(equalToConstant: 90),
            
        ])
        
        if RoleManager.shared.currentRole == "user" {
            contentView.addSubview(ordersButton)
            contentView.addSubview(auctionCardView)
            auctionCardView.addSubview(auctionTitleLabel)
            auctionCardView.addSubview(auctionStatsStackView)
            NSLayoutConstraint.activate([
                auctionCardView.topAnchor.constraint(equalTo: infoCardView.bottomAnchor, constant: 18),
                auctionCardView.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor),
                auctionCardView.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor),
                auctionTitleLabel.topAnchor.constraint(equalTo: auctionCardView.topAnchor, constant: 24),
                auctionTitleLabel.leadingAnchor.constraint(equalTo: auctionCardView.leadingAnchor, constant: 20),
                auctionTitleLabel.trailingAnchor.constraint(equalTo: auctionCardView.trailingAnchor, constant: -20),
                auctionStatsStackView.topAnchor.constraint(equalTo: auctionTitleLabel.bottomAnchor, constant: 24),
                auctionStatsStackView.leadingAnchor.constraint(equalTo: auctionCardView.leadingAnchor, constant: 20),
                auctionStatsStackView.trailingAnchor.constraint(equalTo: auctionCardView.trailingAnchor, constant: -20),
                auctionStatsStackView.bottomAnchor.constraint(equalTo: auctionCardView.bottomAnchor, constant: -24),
                auctionStatsStackView.heightAnchor.constraint(equalToConstant: 90),
                
                ordersButton.topAnchor.constraint(equalTo: auctionCardView.bottomAnchor, constant: 20),
                ordersButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
                ordersButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
                ordersButton.heightAnchor.constraint(equalToConstant: 58),
                
                logoutButton.topAnchor.constraint(equalTo: ordersButton.bottomAnchor, constant: 20),
                logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
                logoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
                logoutButton.heightAnchor.constraint(equalToConstant: 58),
                logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
            ])
        } else {
            NSLayoutConstraint.activate([
                logoutButton.topAnchor.constraint(equalTo: infoCardView.bottomAnchor, constant: 24),
                logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
                logoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
                logoutButton.heightAnchor.constraint(equalToConstant: 58),
                logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
            ])
        }
    }
    
    private func setupBindings() {

        viewModel.onLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading
                ? self?.showLoading()
                : self?.hideLoading()
            }
        }

        viewModel.onAuctionStatsUpdated = {
            [weak self] won, leading in

            DispatchQueue.main.async {

                self?.updateInfoView(
                    tag: 2001,
                    value: "\(won)"
                )

                self?.updateInfoView(
                    tag: 2002,
                    value: "\(leading)"
                )
            }
        }

        viewModel.onLogoutSuccess = { [weak self] in

            DispatchQueue.main.async {

                if let sceneDelegate =
                    UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {

                    sceneDelegate.window?.rootViewController =
                    UINavigationController(
                        rootViewController: LoginViewController()
                    )
                }
            }
        }

        viewModel.onError = { [weak self] message in

            DispatchQueue.main.async {

                self?.hideLoading()

                self?.showAlert(message: message)
            }
        }
    }
    
    // MARK: - Setup Data
    
    private func setupData() {

        nameLabel.text = viewModel.userName
        emailLabel.text = viewModel.userEmail

        roleBadgeLabel.text =
        "  \(viewModel.roleText)  "
    }
    
    // MARK: - Helper View
    
    private func createInfoView(
        title: String,
        value: String
    ) -> UIView {
        
        let containerView = UIView()
        
        containerView.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.08)
        containerView.layer.cornerRadius = 18
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 18, weight: .bold)
        valueLabel.textColor = .systemIndigo
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            valueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])
        
        return containerView
    }
    
    private func updateInfoView(
        tag: Int,
        value: String
    ) {

        if let container =
            view.viewWithTag(tag) {
            for subview in container.subviews {
                if let label = subview as? UILabel,
                   label.font.pointSize == 18 {
                    label.text = value
                }
            }
        }
    }
    
    @objc
    private func openOrders() {

        let vc = UserOrdersViewController()

        navigationController?.pushViewController(
            vc,
            animated: true
        )
    }
    
    @objc private func logoutTapped() {
        viewModel.logout()
    }
}
