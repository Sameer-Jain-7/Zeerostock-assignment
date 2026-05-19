//
//  AddProductViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 16/05/26.
//

import Foundation

final class AddProductViewModel {

    // MARK: - Bindings

    var onLoading: ((Bool) -> Void)?
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?

    // MARK: - Form Fields

    var title: String = ""
    var description: String = ""
    var priceText: String = ""
    var imageUrl: String = ""

    // MARK: - Upload Product

    func uploadProduct() {

        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            onError?("Please enter product title")
            return
        }

        guard !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            onError?("Please enter description")
            return
        }

        guard !imageUrl.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            onError?("Please enter image URL")
            return
        }

        guard let price = Double(priceText) else {
            onError?("Please enter valid price")
            return
        }

        guard price > 0 else {
            onError?("Price should be greater than 0")
            return
        }

        onLoading?(true)

        ProductService.shared.createProduct(
            title: title,
            description: description,
            price: price,
            imageUrl: imageUrl
        ) { [weak self] result in

            self?.onLoading?(false)

            switch result {

            case .success:
                self?.onSuccess?()

            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }

    // MARK: - Reset Form

    func resetForm() {
        title = ""
        description = ""
        priceText = ""
        imageUrl = ""
    }
}
