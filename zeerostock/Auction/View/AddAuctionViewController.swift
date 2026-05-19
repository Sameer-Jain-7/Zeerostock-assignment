//
//  AddAuctionViewController.swift
//  zeerostock
//
//  Created by Sameer Jain on 17/05/26.
//

import UIKit

final class AddAuctionViewController: UIViewController {

    private let viewModel = AddAuctionViewModel()

    // MARK: - Fields

    private let titleTextField = UITextField.createTextField(
        placeholder: "Enter Auction Title"
    )

    private let descriptionTextField = UITextField.createTextField(
        placeholder: "Enter Description"
    )

    private let startingPriceTextField = UITextField.createTextField(
        placeholder: "Enter Starting Price"
    )

    private let imageUrlTextField = UITextField.createTextField(
        placeholder: "Enter Image URL"
    )

    // MARK: - Date Picker

    private let endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.minimumDate = Date()
        picker.preferredDatePickerStyle = .compact
        picker.tintColor = .systemIndigo
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    // MARK: - Upload Button

    private let createAuctionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Auction", for: .normal)
        button.backgroundColor = .systemIndigo
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 18
        button.titleLabel?.font = .systemFont(
            ofSize: 18,
            weight: .bold
        )
        button.layer.shadowColor = UIColor.systemIndigo.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowOffset = CGSize(width: 0, height: 8)
        button.layer.shadowRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
    }

    // MARK: - UI

    private func setupUI() {

        title = "Add Bid"

        view.backgroundColor = UIColor.systemGray6

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo

        let containerView = UIView()

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 28

        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.06
        containerView.layer.shadowOffset = CGSize(width: 0, height: 8)
        containerView.layer.shadowRadius = 18

        containerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(containerView)

        containerView.addSubview(titleTextField)
        containerView.addSubview(descriptionTextField)
        containerView.addSubview(startingPriceTextField)
        containerView.addSubview(imageUrlTextField)
        containerView.addSubview(endDatePicker)
        containerView.addSubview(createAuctionButton)

        createAuctionButton.addTarget(
            self,
            action: #selector(createAuctionTapped),
            for: .touchUpInside
        )

        startingPriceTextField.keyboardType = .decimalPad

//        imageUrlTextField.text = "https://picsum.photos/400"

        NSLayoutConstraint.activate([

            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            titleTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 56),

            descriptionTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 18),
            descriptionTextField.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            descriptionTextField.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 56),

            startingPriceTextField.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 18),
            startingPriceTextField.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            startingPriceTextField.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            startingPriceTextField.heightAnchor.constraint(equalToConstant: 56),

            imageUrlTextField.topAnchor.constraint(equalTo: startingPriceTextField.bottomAnchor, constant: 18),
            imageUrlTextField.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            imageUrlTextField.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            imageUrlTextField.heightAnchor.constraint(equalToConstant: 56),

            endDatePicker.topAnchor.constraint(equalTo: imageUrlTextField.bottomAnchor, constant: 24),
            endDatePicker.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),

            createAuctionButton.topAnchor.constraint(equalTo: endDatePicker.bottomAnchor, constant: 36),
            createAuctionButton.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            createAuctionButton.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            createAuctionButton.heightAnchor.constraint(equalToConstant: 58),
            createAuctionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30)
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

        viewModel.onError = { [weak self] message in

            DispatchQueue.main.async {

                self?.showAlert(
                    message: message
                )
            }
        }

        viewModel.onSuccess = { [weak self] in

            DispatchQueue.main.async {

                self?.showAlert(
                    message: "Auction Created Successfully"
                )

                self?.resetFields()
            }
        }
    }
    
    private func resetFields() {

        titleTextField.text = ""

        descriptionTextField.text = ""

        startingPriceTextField.text = ""

        imageUrlTextField.text = ""

        endDatePicker.date =
        Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: Date()
        ) ?? Date()
    }

    // MARK: - Create Auction

    @objc
    private func createAuctionTapped() {

        UIView.animate(withDuration: 0.1) {

            self.createAuctionButton.transform =
            CGAffineTransform(
                scaleX: 0.97,
                y: 0.97
            )

        } completion: { _ in

            UIView.animate(withDuration: 0.1) {

                self.createAuctionButton.transform =
                .identity
            }
        }

        viewModel.title =
        titleTextField.text ?? ""

        viewModel.description =
        descriptionTextField.text ?? ""

        viewModel.imageUrl =
        imageUrlTextField.text ?? ""

        viewModel.startingPriceText =
        startingPriceTextField.text ?? ""

        viewModel.endDate =
        endDatePicker.date

        viewModel.createAuction()
    }
}
