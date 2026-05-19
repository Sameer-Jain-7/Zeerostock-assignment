//
//  OrderItemCellViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 19/05/26.
//

import Foundation

struct OrderItemCellViewModel {

    private let item: OrderItemModel

    init(item: OrderItemModel) {
        self.item = item
    }

    var titleText: String {
        item.title
    }

    var quantityText: String {
        "Quantity: \(item.quantity)"
    }

    var priceText: String {
        let total = item.price * Double(item.quantity)
        return "₹\(String(format: "%.2f", total))"
    }

    var imageURL: URL? {
        URL(string: item.imageUrl)
    }
}
