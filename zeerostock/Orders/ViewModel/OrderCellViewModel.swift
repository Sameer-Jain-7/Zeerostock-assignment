//
//  OrderCellViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 19/05/26.
//

import Foundation
internal import FirebaseCore

struct OrderCellViewModel {

    private let order: OrderModel

    init(order: OrderModel) {
        self.order = order
    }

    var totalText: String {
        "₹\(String(format: "%.2f", order.totalAmount))"
    }

    var dateText: String {

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        return formatter.string(
            from: order.createdAt.dateValue()
        )
    }

    var itemViewModels: [OrderItemCellViewModel] {
        order.orderItems.map {
            OrderItemCellViewModel(item: $0)
        }
    }
}
