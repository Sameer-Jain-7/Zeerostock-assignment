//
//  AdminUserListViewController.swift
//  zeerostock
//
//  Created by Sameer Jain on 17/05/26.
//


import UIKit

final class AdminUserListViewController: UIViewController {

    private let viewModel = AdminUserListViewModel()

    private lazy var tableView: UITableView = {

        let tableView = UITableView()

        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        tableView.register(
            UserTableViewCell.self,
            forCellReuseIdentifier: UserTableViewCell.identifier
        )

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.sectionFooterHeight = 12

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()

        viewModel.fetchUsers()
    }

    private func setupUI() {

        title = "Users List"

        view.backgroundColor = UIColor.systemGray6

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo

        view.addSubview(tableView)

        NSLayoutConstraint.activate([

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
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

                self?.tableView.reloadData()
            }
        }

        viewModel.onError = { [weak self] message in

            DispatchQueue.main.async {

                self?.hideLoading()

                self?.showAlert(message: message)
            }
        }
    }
}

extension AdminUserListViewController:
UITableViewDelegate,
UITableViewDataSource {

    func numberOfSections(
        in tableView: UITableView
    ) -> Int {

        viewModel.users.count
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserTableViewCell.identifier,
            for: indexPath
        ) as? UserTableViewCell else {

            return UITableViewCell()
        }

        let cellViewModel = UserCellViewModel(
            user: viewModel.users[indexPath.section]
        )

        cell.configure(with: cellViewModel)

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int
    ) -> CGFloat {

        12
    }

    func tableView(
        _ tableView: UITableView,
        viewForFooterInSection section: Int
    ) -> UIView? {

        let view = UIView()

        view.backgroundColor = .clear

        return view
    }
}
