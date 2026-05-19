//
//  OrderItemModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 18/05/26.
//

import Foundation

struct OrderItemModel {

    let title: String

    let quantity: Int

    let price: Double

    let imageUrl: String

    init(data: [String: Any]) {

        self.title = data["title"] as? String ?? ""

        self.quantity = data["quantity"] as? Int ?? 0

        self.price = data["price"] as? Double ?? 0

        self.imageUrl = data["imageUrl"] as? String ?? ""
    }
}
