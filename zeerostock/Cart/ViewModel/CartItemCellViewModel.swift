//
//  CartItemCellViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 19/05/26.
//

import Foundation

struct CartItemCellViewModel {

    private let item: CartItemModel

    init(item: CartItemModel) {
        self.item = item
    }

    var titleText: String {
        item.product.title
    }

    var quantityText: String {
        "Quantity: \(item.quantity)"
    }

    var totalPriceText: String {
        let total = item.product.price * Double(item.quantity)
        return "₹\(String(format: "%.2f", total))"
    }

    var imageURL: URL? {
        URL(string: item.product.imageUrl)
    }

    var productId: String {
        item.product.id
    }
}
