//
//  CartViewController.swift
//  zeerostock
//
//  Created by Sameer Jain on 18/05/26.
//

import UIKit

final class CartViewController: UIViewController {

    private let viewModel = CartViewModel()
    private lazy var tableView: UITableView = {

        let tableView = UITableView()

        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120

        tableView.register(
            CartItemTableViewCell.self,
            forCellReuseIdentifier:
                CartItemTableViewCell.identifier
        )

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        return tableView
    }()

    private let checkoutButton: UIButton = {

        let button = UIButton(type: .system)
        button.setTitle("Proceed To Payment", for: .normal)
        button.backgroundColor = .systemIndigo
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 18
        button.titleLabel?.font = .systemFont(
            ofSize: 18,
            weight: .bold
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let emptyCartLabel: UILabel = {
        let label = UILabel()
        label.text = "🛒 Your cart is empty"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchCartItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchCartItems()
    }

    private func setupUI() {

        title = "Cart"

        view.backgroundColor = UIColor.systemGray6

        view.addSubview(tableView)
        view.addSubview(emptyCartLabel)
        view.addSubview(checkoutButton)

        checkoutButton.addTarget(
            self,
            action: #selector(checkoutTapped),
            for: .touchUpInside
        )

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: checkoutButton.topAnchor, constant: -16),
            
            emptyCartLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyCartLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            emptyCartLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emptyCartLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            checkoutButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupBindings() {

        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.updateCartUI()
            }
        }

        viewModel.onLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading
                ? self?.showLoading()
                : self?.hideLoading()
            }
        }

        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(message: message)
            }
        }

        viewModel.onOrderPlaced = { [weak self] in
            DispatchQueue.main.async {
                self?.showSuccessAlert()
            }
        }
    }

    private func updateCartUI() {
        let isEmpty = viewModel.isCartEmpty()
        checkoutButton.isEnabled = !isEmpty
        checkoutButton.backgroundColor = isEmpty ? .systemGray3 : .systemIndigo
        checkoutButton.alpha = isEmpty ? 0.7 : 1
        tableView.isHidden = isEmpty
        emptyCartLabel.isHidden = !isEmpty
    }
    
    @objc
    private func checkoutTapped() {
        viewModel.checkout()
    }

    private func showSuccessAlert() {

        let alert = UIAlertController(
            title: "Payment Successful",
            message: "Order placed successfully.",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "Awesome",
                style: .default
            )
        )

        present(alert, animated: true)
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartItemTableViewCell.identifier,
            for: indexPath
        ) as? CartItemTableViewCell else {
            return UITableViewCell()
        }

        let item = viewModel.item(at: indexPath.row)

        let cellViewModel = CartItemCellViewModel(
            item: item
        )

        cell.configure(with: cellViewModel)

        cell.onIncreaseTapped = { [weak self] in

            self?.viewModel.increaseQuantity(
                productId: cellViewModel.productId
            )
        }

        cell.onDecreaseTapped = { [weak self] in

            self?.viewModel.decreaseQuantity(
                productId: cellViewModel.productId
            )
        }

        return cell
    }
}
