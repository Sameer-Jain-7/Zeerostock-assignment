//
//  ProductCellViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 19/05/26.
//

import Foundation

struct ProductCellViewModel {

    private let product: ProductModel

    init(product: ProductModel) {
        self.product = product
    }

    var titleText: String {
        product.title
    }

    var priceText: String {
        "₹\(String(format: "%.2f", product.price))"
    }

    var imageURL: URL? {
        URL(string: product.imageUrl)
    }
}
