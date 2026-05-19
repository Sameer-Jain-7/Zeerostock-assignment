//
//  ProductModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 16/05/26.
//

import Foundation

struct ProductModel: Codable {

    let id: String
    let title: String
    let description: String
    let price: Double
    let currency: String
    let imageUrl: String
    let approved: Bool
    let responded: Bool

    init(id: String, data: [String: Any]) {

        self.id = id
        self.title = data["title"] as? String ?? ""
        self.description = data["description"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0
        self.currency = "INR"
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.approved = data["approved"] as? Bool ?? false
        self.responded = data["responded"] as? Bool ?? false
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case imageUrl
        case price
        case currency
        case approved
        case responded
    }
}
