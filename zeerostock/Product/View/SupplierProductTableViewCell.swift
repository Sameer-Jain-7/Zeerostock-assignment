//
//  SupplierProductTableViewCell.swift
//  zeerostock
//
//  Created by Sameer Jain on 17/05/26.
//

import UIKit
import SDWebImage

final class SupplierProductTableViewCell: UITableViewCell {

    static let identifier = "SupplierProductTableViewCell"

    private let productImageView: UIImageView = {

        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .secondarySystemBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let titleLabel: UILabel = {

        let label = UILabel()

        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private let priceLabel: UILabel = {

        let label = UILabel()

        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let statusLabel: UILabel = {

        let label = UILabel()

        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI() {

        backgroundColor = .clear
        contentView.backgroundColor = .clear

        selectionStyle = .none

        let containerView = UIView()

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 22

        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.06
        containerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        containerView.layer.shadowRadius = 12

        containerView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(containerView)

        containerView.addSubview(productImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(statusLabel)

        NSLayoutConstraint.activate([

            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            productImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            productImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 76),
            productImageView.heightAnchor.constraint(equalToConstant: 76),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            statusLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            statusLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),

            statusLabel.bottomAnchor.constraint(
                lessThanOrEqualTo: containerView.bottomAnchor,
                constant: -18
            )
        ])
    }

    func configure(with viewModel: SupplierProductCellViewModel) {

        titleLabel.text = viewModel.titleText
        priceLabel.text = viewModel.priceText

        statusLabel.text = viewModel.statusText
        statusLabel.textColor = viewModel.statusColor
        statusLabel.backgroundColor = viewModel.statusBackgroundColor

        statusLabel.layer.cornerRadius = 8
        statusLabel.clipsToBounds = true

        if let url = viewModel.imageURL {

            productImageView.sd_setImage(
                with: url,
                placeholderImage: UIImage(systemName: "photo")
            )
        }
    }
}

