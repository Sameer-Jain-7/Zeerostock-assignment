//
//  OrderTableViewCell.swift
//  zeerostock
//
//  Created by Sameer Jain on 18/05/26.
//

import UIKit
internal import FirebaseCore

final class OrderTableViewCell: UITableViewCell {

    static let identifier = "OrderTableViewCell"

    private let cardView: UIView = {

        let view = UIView()

        view.backgroundColor = .white

        view.layer.cornerRadius = 24

        view.layer.shadowColor = UIColor.black.cgColor

        view.layer.shadowOpacity = 0.06

        view.layer.shadowOffset = CGSize(
            width: 0,
            height: 5
        )

        view.layer.shadowRadius = 12

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let dateLabel: UILabel = {

        let label = UILabel()

        label.font = .systemFont(
            ofSize: 14,
            weight: .medium
        )

        label.textColor = .secondaryLabel

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let totalLabel: UILabel = {

        let label = UILabel()

        label.font = .systemFont(
            ofSize: 20,
            weight: .bold
        )

        label.textColor = .systemIndigo

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let itemsStackView: UIStackView = {

        let stackView = UIStackView()

        stackView.axis = .vertical

        stackView.spacing = 18

        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
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

        contentView.addSubview(cardView)

        cardView.addSubview(dateLabel)

        cardView.addSubview(totalLabel)

        cardView.addSubview(itemsStackView)

        NSLayoutConstraint.activate([

            cardView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 10
            ),

            cardView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            cardView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            cardView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -10
            ),

            dateLabel.topAnchor.constraint(
                equalTo: cardView.topAnchor,
                constant: 20
            ),

            dateLabel.leadingAnchor.constraint(
                equalTo: cardView.leadingAnchor,
                constant: 20
            ),

            totalLabel.topAnchor.constraint(
                equalTo: dateLabel.bottomAnchor,
                constant: 10
            ),

            totalLabel.leadingAnchor.constraint(
                equalTo: dateLabel.leadingAnchor
            ),

            itemsStackView.topAnchor.constraint(
                equalTo: totalLabel.bottomAnchor,
                constant: 24
            ),

            itemsStackView.leadingAnchor.constraint(
                equalTo: cardView.leadingAnchor,
                constant: 20
            ),

            itemsStackView.trailingAnchor.constraint(
                equalTo: cardView.trailingAnchor,
                constant: -20
            ),

            itemsStackView.bottomAnchor.constraint(
                equalTo: cardView.bottomAnchor,
                constant: -20
            )
        ])
    }

    func configure(
        with viewModel: OrderCellViewModel
    ) {

        itemsStackView.arrangedSubviews.forEach {

            itemsStackView.removeArrangedSubview($0)

            $0.removeFromSuperview()
        }

        totalLabel.text = viewModel.totalText
        dateLabel.text = viewModel.dateText

        viewModel.itemViewModels.forEach { itemViewModel in

            let itemView = OrderItemView()

            itemView.configure(
                with: itemViewModel
            )

            itemsStackView.addArrangedSubview(
                itemView
            )
        }
    }
}
