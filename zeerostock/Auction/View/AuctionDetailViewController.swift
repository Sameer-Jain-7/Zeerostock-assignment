//
//  AuctionDetailViewController.swift
//  zeerostock
//
//  Created by Sameer Jain on 17/05/26.
//

import UIKit
import SDWebImage
import FirebaseAuth

final class AuctionDetailViewController: UIViewController {

    private let viewModel: AuctionDetailViewModel
    private let scrollView = UIScrollView()
    var userRole: String?
    private var timer: Timer?
    private var hasShownAuctionEndAlert = false

    init(auction: AuctionModel) {
        self.viewModel = AuctionDetailViewModel(
            auction: auction
        )
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }


    private let auctionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .secondarySystemBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let imageOverlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 28,
            weight: .bold
        )
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bidContainerView: UIView = {
        let view = UIView()
        view.backgroundColor =
        UIColor.systemIndigo.withAlphaComponent(0.08)
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let currentBidLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 24,
            weight: .bold
        )
        label.textColor = .systemIndigo
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let endTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 15,
            weight: .medium
        )
        label.textColor = .systemOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Bid Button

    private let bidButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Place Bid", for: .normal)
        button.backgroundColor = .systemIndigo
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 18
        button.titleLabel?.font = .systemFont(
            ofSize: 18,
            weight: .bold
        )
        button.layer.shadowColor = UIColor.systemIndigo.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowOffset = CGSize(width: 0, height: 8)
        button.layer.shadowRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let approveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Approve", for: .normal)
        button.backgroundColor = .systemIndigo
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 18
        button.titleLabel?.font = .systemFont(
            ofSize: 17,
            weight: .bold
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let rejectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reject", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 18
        button.titleLabel?.font = .systemFont(
            ofSize: 17,
            weight: .bold
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let bidTextField: UITextField = {
        let uiTextField = UITextField()
        uiTextField.placeholder = "Enter Bid Amount"
        uiTextField.keyboardType = .decimalPad
        uiTextField.borderStyle = .roundedRect
        uiTextField.translatesAutoresizingMaskIntoConstraints = false
        return uiTextField
    }()
    
    private let countdownLabel = UILabel()
    
    private let bidStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 16,
            weight: .semibold
        )
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading()
        setupBindings()
        viewModel.observeAuction()
        startTimer()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.65).cgColor
        ]
        gradient.frame = imageOverlayView.bounds
        imageOverlayView.layer.sublayers?.removeAll()
        imageOverlayView.layer.addSublayer(gradient)
    }

    // MARK: - UI

    private func setupUI() {
        title = "Auction"
        view.backgroundColor = UIColor.systemGray6
        navigationController?.navigationBar.tintColor = .systemIndigo

        let cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 28
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowOffset = CGSize(width: 0, height: 8)
        cardView.layer.shadowRadius = 18
        cardView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.addSubview(cardView)

        cardView.addSubview(auctionImageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(descriptionLabel)
        cardView.addSubview(bidContainerView)
        bidContainerView.addSubview(currentBidLabel)
        cardView.addSubview(endTimeLabel)
        cardView.addSubview(countdownLabel)
        cardView.addSubview(bidStatusLabel)
        auctionImageView.addSubview(imageOverlayView)
        updateUI()
        
        if userRole == "user" {
            cardView.addSubview(bidButton)
        } else if RoleManager.shared.canManageAuctions &&
                    !viewModel.auction.responded &&
                    viewModel.auction.expired != true {
            cardView.addSubview(approveButton)
            cardView.addSubview(rejectButton)
        }
        cardView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40).isActive = true

        approveButton.addTarget(self, action: #selector(approveTapped), for: .touchUpInside)
        rejectButton.addTarget(self, action: #selector(rejectTapped), for: .touchUpInside)
        bidButton.addTarget(self, action: #selector(placeBidTapped), for: .touchUpInside)

        countdownLabel.font = .monospacedDigitSystemFont(ofSize: 20, weight: .bold)
        countdownLabel.textColor = .systemIndigo
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            auctionImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            auctionImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            auctionImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            auctionImageView.heightAnchor.constraint(equalToConstant: 260),
            
            imageOverlayView.leadingAnchor.constraint(equalTo: auctionImageView.leadingAnchor),
            imageOverlayView.trailingAnchor.constraint(equalTo: auctionImageView.trailingAnchor),
            imageOverlayView.bottomAnchor.constraint(equalTo: auctionImageView.bottomAnchor),
            imageOverlayView.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.topAnchor.constraint(equalTo: auctionImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: auctionImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: auctionImageView.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            bidContainerView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            bidContainerView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            bidContainerView.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            bidContainerView.heightAnchor.constraint(equalToConstant: 60),

            currentBidLabel.centerYAnchor.constraint(equalTo: bidContainerView.centerYAnchor),
            currentBidLabel.leadingAnchor.constraint(equalTo: bidContainerView.leadingAnchor, constant: 20),

            endTimeLabel.topAnchor.constraint(equalTo: bidContainerView.bottomAnchor, constant: 16),
            endTimeLabel.leadingAnchor.constraint(equalTo: bidContainerView.leadingAnchor),
            
            countdownLabel.topAnchor.constraint(equalTo: endTimeLabel.bottomAnchor, constant: 12),
            countdownLabel.leadingAnchor.constraint(equalTo: endTimeLabel.leadingAnchor),

            bidStatusLabel.topAnchor.constraint(equalTo: countdownLabel.bottomAnchor, constant: 16),
            bidStatusLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            bidStatusLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
        ])
        
        if userRole == "user" {

            cardView.addSubview(bidTextField)
            NSLayoutConstraint.activate([
                bidTextField.topAnchor.constraint(equalTo: bidStatusLabel.bottomAnchor, constant: 24),
                bidTextField.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
                bidTextField.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
                bidTextField.heightAnchor.constraint(equalToConstant: 52),

                bidButton.topAnchor.constraint(equalTo: bidTextField.bottomAnchor, constant: 20),
                bidButton.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
                bidButton.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
                bidButton.heightAnchor.constraint(equalToConstant: 58),
                bidButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -30),
            ])

        } else if RoleManager.shared.canManageAuctions &&
                    !viewModel.auction.responded &&
                    viewModel.auction.expired != true {

            NSLayoutConstraint.activate([
                approveButton.topAnchor.constraint(equalTo: bidStatusLabel.bottomAnchor, constant: 20),
                approveButton.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
                approveButton.trailingAnchor.constraint(equalTo: cardView.centerXAnchor, constant: -8),
                approveButton.heightAnchor.constraint(equalToConstant: 54),

                rejectButton.topAnchor.constraint(equalTo: approveButton.topAnchor),
                rejectButton.leadingAnchor.constraint(equalTo: cardView.centerXAnchor, constant: 8),
                rejectButton.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
                rejectButton.heightAnchor.constraint(equalToConstant: 54),
                rejectButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -30),
            ])

        } else {

            NSLayoutConstraint.activate([
                bidStatusLabel.bottomAnchor.constraint( equalTo: cardView.bottomAnchor,constant: -24)
            ])
        }
    }
    
    private func setupBindings() {
        viewModel.onAuctionUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.updateUI()
                self.hideLoading()
            }
        }

        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.hideLoading()
                self?.showAlert(
                    message: message
                )
            }
        }

        viewModel.onBidPlaced = { [weak self] in
            DispatchQueue.main.async {
                self?.showAlert(
                    message: "Bid placed successfully"
                )
            }
        }

        viewModel.onAuctionApproved = { [weak self] in
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: Notification.Name("ReloadAdminAuctions"),
                    object: nil
                )

                self?.navigationController?.popViewController(
                    animated: true
                )
            }
        }
        viewModel.onAuctionRejected = { [weak self] in
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: Notification.Name("ReloadAdminAuctions"),
                    object: nil
                )

                self?.navigationController?.popViewController(
                    animated: true
                )
            }
        }
    }
    
    private func updateUI() {

        titleLabel.text = viewModel.titleText
        descriptionLabel.text = viewModel.descriptionText
        currentBidLabel.text = viewModel.currentBidText
        endTimeLabel.text = viewModel.endTimeText
        if userRole == "user" {
            bidStatusLabel.isHidden = false
            bidStatusLabel.text = viewModel.bidStatusText
            bidStatusLabel.textColor = viewModel.bidStatusColor

        } else {
            bidStatusLabel.isHidden = true
            bidStatusLabel.text = nil
        }
        countdownLabel.text = viewModel.countdownText
        countdownLabel.isHidden = viewModel.shouldHideCountdown

        if let url = viewModel.imageURL {
            auctionImageView.sd_setImage(
                with: url,
                placeholderImage: UIImage(systemName: "photo")
            )
        }

        let isEnabled = viewModel.isBiddingEnabled

        bidButton.isEnabled = isEnabled
        bidTextField.isEnabled = isEnabled

        bidButton.backgroundColor = isEnabled ? .systemIndigo : .systemGray
        bidButton.alpha = isEnabled ? 1 : 0.7
        bidTextField.alpha = isEnabled ? 1 : 0.7

        if !isEnabled {
            bidTextField.text = ""
        }
        if viewModel.isAuctionEnded {
            showAuctionEndAlertIfNeeded()
        }
        hideLoading()
    }
    
    private func startTimer() {

        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [weak self] _ in
            guard let self = self else {
                return
            }

            self.updateUI()
        }
    }
    
    private func showAuctionEndAlertIfNeeded() {
        guard userRole == "user" else {
            return
        }
        guard !hasShownAuctionEndAlert else {
            return
        }
        hasShownAuctionEndAlert = true
        guard let currentUserId =
                Auth.auth().currentUser?.uid else {
            return
        }
        if viewModel.auction.highestBidderId == currentUserId {
            let alert = UIAlertController(
                title: "Auction Won",
                message: "Congratulations! You won this auction.",
                preferredStyle: .alert
            )
            alert.addAction(
                UIAlertAction(
                    title: "Awesome",
                    style: .default
                )
            )
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(
                title: "Auction Ended",
                message: "This auction has ended.",
                preferredStyle: .alert
            )
            alert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default
                )
            )
            present(alert, animated: true)
        }
    }
    
    @objc private func approveTapped() {

        let alert = UIAlertController(
            title: "Approve Auction",
            message: "Are you sure you want to approve this auction?",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel
            )
        )

        alert.addAction(
            UIAlertAction(
                title: "Approve",
                style: .default
            ) { [weak self] _ in

                self?.viewModel.approveAuction()
            }
        )

        present(alert, animated: true)
    }

    @objc private func rejectTapped() {

        let alert = UIAlertController(
            title: "Reject Auction",
            message: "Are you sure you want to reject this auction?",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel
            )
        )

        alert.addAction(
            UIAlertAction(
                title: "Reject",
                style: .destructive
            ) { [weak self] _ in

                self?.viewModel.rejectAuction()
            }
        )

        present(alert, animated: true)
    }
    
    @objc private func placeBidTapped() {

        viewModel.placeBid(
            amountText: bidTextField.text
        )
    }
    
    deinit {
        timer?.invalidate()
    }
}
