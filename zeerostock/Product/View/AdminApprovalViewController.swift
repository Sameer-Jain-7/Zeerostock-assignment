//
//  AdminApprovalViewController.swift
//  zeerostock
//
//  Created by Sameer Jain on 17/05/26.
//

import UIKit

final class AdminApprovalViewController: UIViewController {

    private let viewModel = AdminApprovalViewModel()
    private var filteredProducts: [ProductModel] = []
    private let refreshControl = UIRefreshControl()

    private lazy var tableView: UITableView = {

        let tableView = UITableView()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        tableView.register(
            SupplierProductTableViewCell.self,
            forCellReuseIdentifier: SupplierProductTableViewCell.identifier
        )

        return tableView
    }()
    
    private let hintLabel: UILabel = {

        let label = UILabel()
        label.text = "← Swipe left on a product to approve or reject Pending Products"
        label.numberOfLines = 0
        label.font = .systemFont(
            ofSize: 14,
            weight: .medium
        )
        label.textColor = .systemIndigo
        label.textAlignment = .left
        label.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.08)
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadProducts),
            name: Notification.Name("ReloadAdminProducts"),
            object: nil
        )
        setupUI()
        fetchProducts()
        setupBindings()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        fetchProducts()
//    }

    private func setupUI() {

        title = "Product"

        view.backgroundColor = UIColor.systemGray6

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        tableView.refreshControl = refreshControl
        filterSegmentedControl.addTarget(
            self,
            action: #selector(filterChanged),
            for: .valueChanged
        )

        view.addSubview(hintLabel)
        view.addSubview(filterSegmentedControl)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([

            hintLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            hintLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hintLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            hintLabel.heightAnchor.constraint(equalToConstant: 40),

            filterSegmentedControl.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 12),
            filterSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            filterSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            filterSegmentedControl.heightAnchor.constraint(equalToConstant: 36),

            tableView.topAnchor.constraint(equalTo: filterSegmentedControl.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
                self?.applyFilter()
                self?.refreshControl.endRefreshing()
            }
        }

        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.hideLoading()
                self?.refreshControl.endRefreshing()
                self?.showAlert(message: message)
            }
        }
    }

    private func fetchProducts() {
        viewModel.fetchProducts()
    }
    
    private let filterSegmentedControl: UISegmentedControl = {

        let segmentedControl = UISegmentedControl(
            items: [
                "All",
                "Pending"
            ]
        )

        segmentedControl.selectedSegmentIndex = 0

        segmentedControl.selectedSegmentTintColor = .systemIndigo

        segmentedControl.setTitleTextAttributes(
            [
                .foregroundColor: UIColor.white
            ],
            for: .selected
        )

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false

        return segmentedControl
    }()
    
    @objc
    private func filterChanged() {
        applyFilter()
    }
    
    @objc
    private func reloadProducts() {
        fetchProducts()
    }
    
    @objc
    private func refreshPulled() {
        viewModel.fetchProducts()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AdminApprovalViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        filteredProducts.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SupplierProductTableViewCell.identifier,
            for: indexPath
        ) as? SupplierProductTableViewCell else {
            return UITableViewCell()
        }
        let product = filteredProducts[indexPath.row]
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

        tableView.deselectRow(at: indexPath, animated: true)

        let product = filteredProducts[indexPath.row]

        let vc = ProductDetailViewController(product: product)
        vc.userRole = "super_admin"

        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        let product = filteredProducts[indexPath.row]

        if product.responded {
            return nil
        }
        
        let approveAction = UIContextualAction(
            style: .normal,
            title: "Approve"
        ) { [weak self] _, _, completion in
            self?.viewModel.approveProduct(
                productId: product.id
            )
            completion(true)
        }

        approveAction.backgroundColor = .systemIndigo

        let rejectAction = UIContextualAction(
            style: .destructive,
            title: "Reject"
        ) { [weak self] _, _, completion in

            self?.viewModel.rejectProduct(
                productId: product.id
            )

            completion(true)
        }

        let configuration = UISwipeActionsConfiguration(
            actions: [
                rejectAction,
                approveAction
            ]
        )

        configuration.performsFirstActionWithFullSwipe = false

        return configuration
    }
    
    private func applyFilter() {
        switch filterSegmentedControl.selectedSegmentIndex {
        case 1:
            filteredProducts = viewModel.products.filter {
                !$0.responded
            }
        default:
            filteredProducts = viewModel.products
        }
        tableView.reloadData()
    }
}

