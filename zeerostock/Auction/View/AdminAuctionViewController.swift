//
//  AdminAuctionViewController.swift
//  zeerostock
//
//  Created by Sameer Jain on 17/05/26.
//

import UIKit

final class AdminAuctionViewController: UIViewController {

    private let viewModel = AdminAuctionViewModel()
    private var filteredAuctions: [AuctionModel] = []

    private lazy var tableView: UITableView = {

        let tableView = UITableView()

        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.register(AuctionTableViewCell.self, forCellReuseIdentifier: AuctionTableViewCell.identifier)

        return tableView
    }()

    private let hintLabel: UILabel = {

        let label = UILabel()
        label.text = "← Swipe left on an auction to approve or reject Pending Auctions"
        label.numberOfLines = 0
        label.textAlignment = .left
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

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadAuctions),
            name: Notification.Name("ReloadAdminAuctions"),
            object: nil
        )
        setupUI()
        setupBindings()
        viewModel.fetchAuctions()
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        viewModel.fetchAuctions()
//    }

    private func setupUI() {

        title = "Auction"

        view.backgroundColor = UIColor.systemGray6

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
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
            }
        }
        viewModel.onError = { [weak self] message in

            DispatchQueue.main.async {

                self?.showAlert(
                    message: message
                )
            }
        }
    }
    
    private func applyFilter() {
        switch filterSegmentedControl.selectedSegmentIndex {
        case 1:
            filteredAuctions = viewModel.auctions.filter {
                !$0.responded &&
                $0.expired != true
            }

        default:
            filteredAuctions = viewModel.auctions
        }
        tableView.reloadData()
    }
    @objc
    private func filterChanged() {
        applyFilter()
    }
    
    @objc
    private func reloadAuctions() {
        viewModel.fetchAuctions()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AdminAuctionViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        filteredAuctions.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier:
                AuctionTableViewCell.identifier,
            for: indexPath
        ) as? AuctionTableViewCell else {

            return UITableViewCell()
        }

        let auction =
        filteredAuctions[indexPath.row]

        let cellViewModel =
        AuctionCellViewModel(
            auction: auction
        )

        cell.configure(
            with: cellViewModel
        )

        return cell
    }
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        tableView.deselectRow(at: indexPath, animated: true)

        let auction = filteredAuctions[indexPath.row]

        let vc = AuctionDetailViewController(
            auction: auction
        )

        vc.userRole = "super_admin"

        navigationController?.pushViewController(
            vc,
            animated: true
        )
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        let auction = filteredAuctions[indexPath.row]
        if auction.responded ||
            auction.expired == true {
            return nil
        }

        let approveAction = UIContextualAction(
            style: .normal,
            title: "Approve"
        ) { [weak self] _, _, completion in

            let alert = UIAlertController(
                title: "Approve Auction",
                message: "Are you sure you want to approve this auction?",
                preferredStyle: .alert
            )

            alert.addAction(
                UIAlertAction(
                    title: "Cancel",
                    style: .cancel
                ) { _ in
                    completion(false)
                }
            )

            alert.addAction(
                UIAlertAction(
                    title: "Approve",
                    style: .default
                ) { [weak self] _ in

                    self?.viewModel.approveAuction(
                        auctionId: auction.id
                    )

                    completion(true)
                }
            )

            self?.present(alert, animated: true)
        }

        approveAction.backgroundColor = .systemIndigo

        let rejectAction = UIContextualAction(
            style: .destructive,
            title: "Reject"
        ) { [weak self] _, _, completion in

            let alert = UIAlertController(
                title: "Reject Auction",
                message: "Are you sure you want to reject this auction?",
                preferredStyle: .alert
            )

            alert.addAction(
                UIAlertAction(
                    title: "Cancel",
                    style: .cancel
                ) { _ in
                    completion(false)
                }
            )

            alert.addAction(
                UIAlertAction(
                    title: "Reject",
                    style: .destructive
                ) { [weak self] _ in

                    self?.viewModel.rejectAuction(
                        auctionId: auction.id
                    )

                    completion(true)
                }
            )

            self?.present(alert, animated: true)
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
}
