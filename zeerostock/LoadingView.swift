//
//  LoadingView.swift
//  zeerostock
//
//  Created by Sameer Jain on 18/05/26.
//

import UIKit

final class LoadingView: UIView {

    private let blurView: UIVisualEffectView = {

        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)

        let view = UIVisualEffectView(effect: blurEffect)

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let containerView: UIView = {

        let view = UIView()

        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)

        view.layer.cornerRadius = 28

        view.layer.shadowColor = UIColor.black.cgColor

        view.layer.shadowOpacity = 0.12

        view.layer.shadowOffset = CGSize(width: 0, height: 8)

        view.layer.shadowRadius = 20

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let activityIndicator: UIActivityIndicatorView = {

        let indicator = UIActivityIndicatorView(style: .large)

        indicator.color = .systemIndigo

        indicator.startAnimating()

        indicator.translatesAutoresizingMaskIntoConstraints = false

        return indicator
    }()

    private let titleLabel: UILabel = {

        let label = UILabel()

        label.text = "Loading"

        label.font = .systemFont(ofSize: 24, weight: .bold)

        label.textColor = .label

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let subtitleLabel: UILabel = {

        let label = UILabel()

        label.text = "Please wait while we fetch data"

        label.font = .systemFont(ofSize: 15, weight: .medium)

        label.textColor = .secondaryLabel

        label.textAlignment = .center

        label.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    override init(frame: CGRect) {

        super.init(frame: frame)

        setupUI()

        animateContainer()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI() {

        backgroundColor = UIColor.black.withAlphaComponent(0.15)

        translatesAutoresizingMaskIntoConstraints = false

        addSubview(blurView)

        addSubview(containerView)

        containerView.addSubview(activityIndicator)

        containerView.addSubview(titleLabel)

        containerView.addSubview(subtitleLabel)

        NSLayoutConstraint.activate([

            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),

            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),

            activityIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 28),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            subtitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -28)
        ])
    }

    private func animateContainer() {

        containerView.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)

        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.4,
            options: [.repeat, .autoreverse]
        ) {

            self.containerView.transform = .identity
        }
    }
}
