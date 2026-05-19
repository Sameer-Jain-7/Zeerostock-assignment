//
//  SupplierProductsViewController.swift
//  zeerostock
//
//  Created by Sameer Jain on 16/05/26.
//

import UIKit

final class SupplierProductsViewController: UIViewController {

    private let viewModel = SupplierProductsViewModel()
    private let refreshControl = UIRefreshControl()
    private var hasLoadedProducts = false

    private lazy var tableView: UITableView = {

        let tableView = UITableView()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(
            SupplierProductTableViewCell.self,
            forCellReuseIdentifier: SupplierProductTableViewCell.identifier
        )

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        tableView.refreshControl = refreshControl
        return tableView
    }()

    private let emptyLabel: UILabel = {

        let label = UILabel()

        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text =
        "Nothing to Show. Please add New Products"

        label.isHidden = true

        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
        fetchProducts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.refreshProductsIfNeeded()
    }

    private func setupUI() {

        title = "Products"

        view.backgroundColor = UIColor.systemGray6

        navigationController?
            .navigationBar
            .prefersLargeTitles = true

        view.addSubview(tableView)
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    private func setupBindings() {

        viewModel.onLoading = { [weak self] isLoading in

            DispatchQueue.main.async {

                isLoading
                ? self?.showLoading()
                : self?.hideLoading()
            }
        }

        viewModel.onDataUpdated = { [weak self] in

            DispatchQueue.main.async {

                guard let self = self else {
                    return
                }

                let isEmpty =
                self.viewModel.products.isEmpty

                self.tableView.isHidden = isEmpty
                self.emptyLabel.isHidden = !isEmpty

                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
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
    }

    private func fetchProducts() {

        guard !hasLoadedProducts else {
            return
        }

        hasLoadedProducts = true

        viewModel.fetchProducts()
    }
    
    @objc private func refreshPulled() {

        viewModel.fetchProducts()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.refreshControl.endRefreshing()
        }
    }
}

extension SupplierProductsViewController:
UITableViewDelegate,
UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        viewModel.products.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier:
                SupplierProductTableViewCell.identifier,
            for: indexPath
        ) as? SupplierProductTableViewCell else {

            return UITableViewCell()
        }

        let product =
        viewModel.products[indexPath.row]
        let cellViewModel = SupplierProductCellViewModel(
            product: product
        )
        cell.configure(with: cellViewModel)
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        tableView.deselectRow(
            at: indexPath,
            animated: true
        )

        let product =
        viewModel.products[indexPath.row]

        let vc =
        ProductDetailViewController(
            product: product
        )

        vc.userRole = "supplier"

        navigationController?
            .pushViewController(
                vc,
                animated: true
            )
    }
}
