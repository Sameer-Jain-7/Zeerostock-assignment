//
//  SupplierProductCellViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 19/05/26.
//

import Foundation
import UIKit

struct SupplierProductCellViewModel {

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

    var statusText: String {

        if !product.responded {
            return "⌛ Pending Approval"
        }

        if product.approved {
            return "✓ Approved"
        }

        return "✕ Rejected"
    }

    var statusColor: UIColor {

        if !product.responded {
            return .systemOrange
        }

        if product.approved {
            return .systemGreen
        }

        return .systemRed
    }

    var statusBackgroundColor: UIColor {

        if !product.responded {
            return UIColor.systemOrange.withAlphaComponent(0.12)
        }

        if product.approved {
            return UIColor.systemGreen.withAlphaComponent(0.12)
        }

        return UIColor.systemRed.withAlphaComponent(0.12)
    }

    var imageURL: URL? {
        URL(string: product.imageUrl)
    }
}
