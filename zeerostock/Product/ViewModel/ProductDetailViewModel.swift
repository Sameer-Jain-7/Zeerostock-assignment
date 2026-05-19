//
//  ProductDetailViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 19/05/26.
//

import Foundation
import UIKit

final class ProductDetailViewModel {

    private(set) var product: ProductModel

    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?

    init(product: ProductModel) {
        self.product = product
    }

    var titleText: String {
        product.title
    }

    var descriptionText: String {
        product.description
    }

    var priceText: String {
        "₹\(String(format: "%.2f", product.price))"
    }

    var imageURL: URL? {
        URL(string: product.imageUrl)
    }

    var shouldShowCartButton: Bool {
        true
    }

    func approveProduct() {

        ProductService.shared.approveProduct(
            productId: product.id
        ) { [weak self] result in

            switch result {

            case .success:
                self?.onSuccess?()

            case .failure(let error):
                self?.onError?(
                    error.localizedDescription
                )
            }
        }
    }

    func rejectProduct() {

        ProductService.shared.rejectProduct(
            productId: product.id
        ) { [weak self] result in

            switch result {

            case .success:
                self?.onSuccess?()

            case .failure(let error):
                self?.onError?(
                    error.localizedDescription
                )
            }
        }
    }

    func addToCart() {
        CartService.shared.addToCart(
            product: product
        )
    }
}
