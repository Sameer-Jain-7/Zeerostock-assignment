//
//  CartItemModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 18/05/26.
//

import Foundation

struct CartItemModel: Codable {

    let product: ProductModel
    var quantity: Int
}
