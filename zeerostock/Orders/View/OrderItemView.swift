//
//  OrderItemView.swift
//  zeerostock
//
//  Created by Sameer Jain on 18/05/26.
//

import UIKit
import SDWebImage

final class OrderItemView: UIView {

    private let productImageView: UIImageView = {

        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill

        imageView.layer.cornerRadius = 12

        imageView.clipsToBounds = true

        imageView.backgroundColor =
        .secondarySystemBackground

        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let titleLabel: UILabel = {

        let label = UILabel()

        label.font = .boldSystemFont(ofSize: 15)

        label.numberOfLines = 2

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let quantityLabel: UILabel = {

        let label = UILabel()

        label.font = .systemFont(
            ofSize: 14,
            weight: .medium
        )

        label.textColor = .secondaryLabel

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let priceLabel: UILabel = {

        let label = UILabel()

        label.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )

        label.textColor = .systemIndigo

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    override init(frame: CGRect) {

        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI() {

        translatesAutoresizingMaskIntoConstraints = false

        addSubview(productImageView)

        addSubview(titleLabel)

        addSubview(quantityLabel)

        addSubview(priceLabel)

        NSLayoutConstraint.activate([

            productImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),

            productImageView.topAnchor.constraint(
                equalTo: topAnchor
            ),

            productImageView.widthAnchor.constraint(
                equalToConstant: 70
            ),

            productImageView.heightAnchor.constraint(
                equalToConstant: 70
            ),

            titleLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 4
            ),

            titleLabel.leadingAnchor.constraint(
                equalTo: productImageView.trailingAnchor,
                constant: 14
            ),

            titleLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),

            quantityLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 8
            ),

            quantityLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),

            priceLabel.topAnchor.constraint(
                equalTo: quantityLabel.bottomAnchor,
                constant: 8
            ),

            priceLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),

            priceLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -4
            )
        ])
    }

    func configure(
        with viewModel: OrderItemCellViewModel
    ) {

        titleLabel.text = viewModel.titleText
        quantityLabel.text = viewModel.quantityText
        priceLabel.text = viewModel.priceText

        if let url = viewModel.imageURL {

            productImageView.sd_setImage(
                with: url,
                placeholderImage: UIImage(
                    systemName: "photo"
                )
            )
        }
    }
}
