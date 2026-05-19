//
//  ProductDetailViewController.swift
//  zeerostock
//
//  Created by Sameer Jain on 16/05/26.
//

import UIKit
import SDWebImage

final class ProductDetailViewController: UIViewController {
    
    let scrollView = UIScrollView()
    var userRole: String?
    private let viewModel: ProductDetailViewModel
    
    init(product: ProductModel) {
        self.viewModel = ProductDetailViewModel(
            product: product
        )
        super.init(
            nibName: nil,
            bundle: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private let productImageView: UIImageView = {

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
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .systemIndigo
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addToCartButton: UIButton = {

        let button = UIButton(type: .system)
        button.setTitle("Add To Cart", for: .normal)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
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
    
    private func setupUI() {

        title = "Product Details"
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

        if let url = viewModel.imageURL {

            productImageView.sd_setImage(
                with: url,
                placeholderImage: UIImage(systemName: "photo")
            )
        }

        titleLabel.text = viewModel.titleText
        descriptionLabel.text = viewModel.descriptionText
        priceLabel.text = "\(viewModel.priceText)"

        priceLabel.textColor = .systemIndigo

        view.addSubview(scrollView)
        
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(cardView)
        
        productImageView.addSubview(imageOverlayView)
        
        
        cardView.addSubview(productImageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(descriptionLabel)
        cardView.addSubview(priceLabel)
        if userRole == "user" {
            cardView.addSubview(addToCartButton)
        } else if RoleManager.shared.canManageProducts && !viewModel.product.responded {
            cardView.addSubview(approveButton)
            cardView.addSubview(rejectButton)
        }
        cardView.widthAnchor.constraint(
            equalTo: scrollView.frameLayoutGuide.widthAnchor,
            constant: -40
        ).isActive = true
        
        approveButton.addTarget(
            self,
            action: #selector(approveTapped),
            for: .touchUpInside
        )

        rejectButton.addTarget(
            self,
            action: #selector(rejectTapped),
            for: .touchUpInside
        )
        
        addToCartButton.addTarget(
            self,
            action: #selector(addToCartTapped),
            for: .touchUpInside
        )

        NSLayoutConstraint.activate([
            
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            cardView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            cardView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            cardView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),

            productImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            productImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            productImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            productImageView.heightAnchor.constraint(equalToConstant: 260),
            
            imageOverlayView.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor),
            imageOverlayView.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor),
            imageOverlayView.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor),
            imageOverlayView.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            priceLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
//            priceLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24)
        ])
        if userRole == "user" {
            NSLayoutConstraint.activate([
                addToCartButton.topAnchor.constraint(
                    equalTo: priceLabel.bottomAnchor,
                    constant: 32
                ),
                addToCartButton.leadingAnchor.constraint(
                    equalTo: descriptionLabel.leadingAnchor
                ),
                addToCartButton.trailingAnchor.constraint(
                    equalTo: descriptionLabel.trailingAnchor
                ),
                addToCartButton.heightAnchor.constraint(equalToConstant: 58),
                addToCartButton.bottomAnchor.constraint(
                    equalTo: cardView.bottomAnchor,
                    constant: -30
                )
            ])

        } else if RoleManager.shared.canManageProducts && !viewModel.product.responded {

            NSLayoutConstraint.activate([
                approveButton.topAnchor.constraint(
                    equalTo: priceLabel.bottomAnchor,
                    constant: 32
                ),
                approveButton.leadingAnchor.constraint(
                    equalTo: descriptionLabel.leadingAnchor
                ),
                approveButton.trailingAnchor.constraint(
                    equalTo: cardView.centerXAnchor,
                    constant: -8
                ),
                approveButton.heightAnchor.constraint(equalToConstant: 54),
                rejectButton.topAnchor.constraint(
                    equalTo: approveButton.topAnchor
                ),
                rejectButton.leadingAnchor.constraint(
                    equalTo: cardView.centerXAnchor,
                    constant: 8
                ),
                rejectButton.trailingAnchor.constraint(
                    equalTo: descriptionLabel.trailingAnchor
                ),
                rejectButton.heightAnchor.constraint(equalToConstant: 54),
                rejectButton.bottomAnchor.constraint(
                    equalTo: cardView.bottomAnchor,
                    constant: -30
                )
            ])

        } else {
            NSLayoutConstraint.activate([
                priceLabel.bottomAnchor.constraint(
                    equalTo: cardView.bottomAnchor,
                    constant: -24
                )
            ])
        }
    }
    
    private func setupBindings() {

        viewModel.onSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }

        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(message: message)
            }
        }
    }
    
    @objc private func approveTapped() {

        viewModel.approveProduct()

        NotificationCenter.default.post(
            name: Notification.Name("ReloadAdminProducts"),
            object: nil
        )
    }

    @objc private func rejectTapped() {

        viewModel.rejectProduct()

        NotificationCenter.default.post(
            name: Notification.Name("ReloadAdminProducts"),
            object: nil
        )
    }

    @objc
    private func addToCartTapped() {

        viewModel.addToCart()

        let alert = UIAlertController(
            title: "Added To Cart",
            message: "\(viewModel.titleText) added successfully.",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "Continue Shopping",
                style: .default
            )
        )

        alert.addAction(
            UIAlertAction(
                title: "Go To Cart",
                style: .default
            ) { [weak self] _ in

                self?.tabBarController?.selectedIndex = 2
            }
        )

        present(alert, animated: true)
    }
}
