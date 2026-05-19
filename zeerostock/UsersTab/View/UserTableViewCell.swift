//
//  UserTableViewCell.swift
//  zeerostock
//
//  Created by Sameer Jain on 19/05/26.
//

import UIKit

final class UserTableViewCell: UITableViewCell {

    static let identifier = "UserTableViewCell"

    private let containerView: UIView = {

        let view = UIView()

        view.backgroundColor = .white
        view.layer.cornerRadius = 18

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.06
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 10

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let nameLabel: UILabel = {

        let label = UILabel()

        label.font = .boldSystemFont(ofSize: 16)

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let detailLabel: UILabel = {

        let label = UILabel()

        label.font = .systemFont(ofSize: 14)

        label.textColor = .secondaryLabel

        label.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {

        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI() {

        backgroundColor = .clear

        contentView.backgroundColor = .clear

        selectionStyle = .none

        contentView.addSubview(containerView)

        containerView.addSubview(nameLabel)
        containerView.addSubview(detailLabel)

        NSLayoutConstraint.activate([

            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            detailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            detailLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    func configure(
        with viewModel: UserCellViewModel
    ) {

        nameLabel.text = viewModel.nameText

        detailLabel.text = viewModel.detailText
    }
}
