//
//  SupplierAuctionsViewController.swift
//  zeerostock
//
//  Created by Sameer Jain on 17/05/26.
//

import UIKit

final class SupplierAuctionsViewController: UIViewController {
    
    private let viewModel = SupplierAuctionsViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AuctionTableViewCell.self, forCellReuseIdentifier: AuctionTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        return tableView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nothing to Show. Please create New Auctions"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchAuctions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchAuctions()
    }
    
    private func setupUI() {

        title = "Auctions"

        view.backgroundColor = UIColor.systemGray6
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
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

                let isEmpty = self.viewModel.auctions.isEmpty
                self.tableView.isHidden = isEmpty
                self.emptyLabel.isHidden = !isEmpty
                self.tableView.reloadData()
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

extension SupplierAuctionsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.auctions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier:
                AuctionTableViewCell.identifier,
            for: indexPath
        ) as? AuctionTableViewCell else {
            return UITableViewCell()
        }
        let auction = viewModel.auctions[indexPath.row]
        let cellViewModel = AuctionCellViewModel( auction: auction)
        cell.configure(with: cellViewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        let auction = viewModel.auctions[indexPath.row]
        let vc = AuctionDetailViewController(auction: auction)
        vc.userRole = "supplier"
        navigationController?.pushViewController(vc, animated: true)
    }
}
