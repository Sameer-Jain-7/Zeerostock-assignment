//
//  CartItemTableViewCell.swift
//  zeerostock
//
//  Created by Sameer Jain on 18/05/26.
//

import UIKit
import SDWebImage

final class CartItemTableViewCell: UITableViewCell {

    static let identifier = "CartItemTableViewCell"
    var onIncreaseTapped: (() -> Void)?
    var onDecreaseTapped: (() -> Void)?

    private let containerView: UIView = {

        let view = UIView()

        view.backgroundColor = .white

        view.layer.cornerRadius = 22

        view.layer.shadowColor = UIColor.black.cgColor

        view.layer.shadowOpacity = 0.06

        view.layer.shadowOffset = CGSize(width: 0, height: 5)

        view.layer.shadowRadius = 12

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let productImageView: UIImageView = {

        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill

        imageView.layer.cornerRadius = 14

        imageView.clipsToBounds = true

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
    
    private let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = .systemFont(
            ofSize: 22,
            weight: .bold
        )
        button.backgroundColor = UIColor.systemGray5
        button.tintColor = .black
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(
            ofSize: 20,
            weight: .bold
        )
        button.backgroundColor = .systemIndigo
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let priceLabel: UILabel = {

        let label = UILabel()

        label.font = .systemFont(
            ofSize: 18,
            weight: .bold
        )

        label.textColor = .systemIndigo

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
        selectionStyle = .none
        contentView.addSubview(containerView)
        containerView.addSubview(productImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(quantityLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(minusButton)
        containerView.addSubview(plusButton)
        
        minusButton.addTarget(
            self,
            action: #selector(minusTapped),
            for: .touchUpInside
        )

        plusButton.addTarget(
            self,
            action: #selector(plusTapped),
            for: .touchUpInside
        )

        NSLayoutConstraint.activate([

            containerView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8
            ),

            containerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            containerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            containerView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -8
            ),

            productImageView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 16
            ),

            productImageView.centerYAnchor.constraint(
                equalTo: containerView.centerYAnchor
            ),

            productImageView.widthAnchor.constraint(
                equalToConstant: 80
            ),

            productImageView.heightAnchor.constraint(
                equalToConstant: 80
            ),

            titleLabel.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: 18
            ),

            titleLabel.leadingAnchor.constraint(
                equalTo: productImageView.trailingAnchor,
                constant: 16
            ),

            titleLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -16
            ),

            minusButton.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 14
            ),

            minusButton.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),

            minusButton.widthAnchor.constraint(
                equalToConstant: 32
            ),

            minusButton.heightAnchor.constraint(
                equalToConstant: 32
            ),

            quantityLabel.centerYAnchor.constraint(
                equalTo: minusButton.centerYAnchor
            ),

            quantityLabel.leadingAnchor.constraint(
                equalTo: minusButton.trailingAnchor,
                constant: 12
            ),

            plusButton.centerYAnchor.constraint(
                equalTo: minusButton.centerYAnchor
            ),

            plusButton.leadingAnchor.constraint(
                equalTo: quantityLabel.trailingAnchor,
                constant: 12
            ),

            plusButton.widthAnchor.constraint(
                equalToConstant: 32
            ),

            plusButton.heightAnchor.constraint(
                equalToConstant: 32
            ),

            priceLabel.topAnchor.constraint(
                equalTo: quantityLabel.bottomAnchor,
                constant: 10
            ),

            priceLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),

            priceLabel.bottomAnchor.constraint(
                lessThanOrEqualTo: containerView.bottomAnchor,
                constant: -18
            )
        ])
    }

    func configure(
        with viewModel: CartItemCellViewModel
    ) {

        titleLabel.text = viewModel.titleText

        quantityLabel.text = viewModel.quantityText

        priceLabel.text = viewModel.totalPriceText

        if let url = viewModel.imageURL {

            productImageView.sd_setImage(
                with: url,
                placeholderImage: UIImage(
                    systemName: "photo"
                )
            )
        }
    }
    
    @objc
    private func plusTapped() {
        onIncreaseTapped?()
    }

    @objc
    private func minusTapped() {
        onDecreaseTapped?()
    }
}
