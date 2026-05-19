//
//  OrderModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 18/05/26.
//

import Foundation
import FirebaseFirestore

struct OrderModel {

    let id: String

    let userId: String

    let totalAmount: Double

    let createdAt: Timestamp

    let orderItems: [OrderItemModel]

    init(
        id: String,
        data: [String: Any]
    ) {

        self.id = id

        self.userId =
        data["userId"] as? String ?? ""

        self.totalAmount =
        data["totalAmount"] as? Double ?? 0

        self.createdAt =
        data["createdAt"] as? Timestamp
        ?? Timestamp()

        let rawItems =
        data["order_items"] as? [[String: Any]]
        ?? []

        self.orderItems = rawItems.map {
            OrderItemModel(data: $0)
        }
    }
}
