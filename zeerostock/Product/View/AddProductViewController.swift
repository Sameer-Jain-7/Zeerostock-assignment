//
//  AddProductViewController.swift
//  zeerostock
//
//  Created by Sameer Jain on 16/05/26.
//

import UIKit

final class AddProductViewController: UIViewController {
    
    private let viewModel = AddProductViewModel()
    
    private let titleTextField = UITextField.createTextField(
        placeholder: "Enter Product Title"
    )
    
    private let descriptionTextField = UITextField.createTextField(
        placeholder: "Enter Description"
    )
    
    private let priceTextField = UITextField.createTextField(
        placeholder: "Enter Price (₹)"
    )
    
    private let imageUrlTextField = UITextField.createTextField(
        placeholder: "Enter Image URL"
    )
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upload Product", for: .normal)
        button.backgroundColor = .systemIndigo
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {

        title = "Add Item"

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
        containerView.addSubview(priceTextField)
        containerView.addSubview(imageUrlTextField)
        containerView.addSubview(addButton)

        addButton.addTarget(
            self,
            action: #selector(addProductTapped),
            for: .touchUpInside
        )

        priceTextField.keyboardType = .decimalPad

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

            priceTextField.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 18),
            priceTextField.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            priceTextField.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            priceTextField.heightAnchor.constraint(equalToConstant: 56),


            imageUrlTextField.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 18),
            imageUrlTextField.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            imageUrlTextField.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            imageUrlTextField.heightAnchor.constraint(equalToConstant: 56),

            addButton.topAnchor.constraint(equalTo: imageUrlTextField.bottomAnchor, constant: 32),
            addButton.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 58),
            addButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30)
        ])
    }
    
    private func setupBindings() {

        viewModel.onLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.showLoading() : self?.hideLoading()
            }
        }

        viewModel.onSuccess = { [weak self] in
            DispatchQueue.main.async {

                self?.showAlert(
                    message: "Product Uploaded Successfully"
                )

                self?.titleTextField.text = ""
                self?.descriptionTextField.text = ""
                self?.priceTextField.text = ""
                self?.imageUrlTextField.text = ""

                self?.viewModel.resetForm()
            }
        }

        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.hideLoading()
                self?.showAlert(message: message)
            }
        }
    }
    
    @objc private func addProductTapped() {

        viewModel.title = titleTextField.text ?? ""
        viewModel.description = descriptionTextField.text ?? ""
        viewModel.priceText = priceTextField.text ?? ""
        viewModel.imageUrl = imageUrlTextField.text ?? ""

        viewModel.uploadProduct()
    }
}
