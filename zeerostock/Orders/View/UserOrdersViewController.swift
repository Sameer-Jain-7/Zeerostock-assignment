//
//  UserOrdersViewController.swift
//  zeerostock
//
//  Created by Sameer Jain on 18/05/26.
//

import UIKit

final class UserOrdersViewController:
UIViewController {

    private let viewModel =
    UserOrdersViewModel()

    private lazy var tableView: UITableView = {

        let tableView = UITableView()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 260
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        tableView.register(
            OrderTableViewCell.self,
            forCellReuseIdentifier:
                OrderTableViewCell.identifier
        )

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()

        viewModel.fetchOrders()
    }

    private func setupUI() {

        title = "My Orders"

        view.backgroundColor =
        UIColor.systemGray6

        navigationController?
            .navigationBar
            .prefersLargeTitles = true

        view.addSubview(tableView)

        NSLayoutConstraint.activate([

            tableView.topAnchor.constraint(
                equalTo:
                    view.safeAreaLayoutGuide.topAnchor,
                constant: 8
            ),

            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }

    private func setupBindings() {

        viewModel.onLoading = {
            [weak self] isLoading in

            DispatchQueue.main.async {

                isLoading
                ? self?.showLoading()
                : self?.hideLoading()
            }
        }

        viewModel.onDataUpdated = {
            [weak self] in

            DispatchQueue.main.async {

                self?.tableView.reloadData()
            }
        }

        viewModel.onError = {
            [weak self] message in

            DispatchQueue.main.async {

                self?.hideLoading()

                self?.showAlert(
                    message: message
                )
            }
        }
    }
}

extension UserOrdersViewController:
UITableViewDelegate,
UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        viewModel.orders.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell =
                tableView.dequeueReusableCell(
                    withIdentifier:
                        OrderTableViewCell.identifier,
                    for: indexPath
                ) as? OrderTableViewCell else {

            return UITableViewCell()
        }

        let cellViewModel =
        OrderCellViewModel(
            order:
                viewModel.orders[indexPath.row]
        )

        cell.configure(
            with: cellViewModel
        )

        return cell
    }
}
