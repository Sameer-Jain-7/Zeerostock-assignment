//
//  AuctionModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 17/05/26.
//

import Foundation
import FirebaseFirestore

struct AuctionModel {

    let id: String
    let title: String
    let description: String
    let imageUrl: String
    let startingPrice: Double
    let currentBid: Double
    let currency: String
    let endTime: Timestamp
    let createdBy: String
    let highestBidderId: String
    let approved: Bool
    let responded: Bool
    let expired: Bool?
    let bidderIds: [String]
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.title = data["title"] as? String ?? ""
        self.description = data["description"] as? String ?? ""
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.startingPrice = data["startingPrice"] as? Double ?? 0
        self.currentBid = data["currentBid"] as? Double ?? 0
        self.currency = "INR"
        self.endTime = data["endTime"] as? Timestamp ?? Timestamp()
        self.createdBy = data["createdBy"] as? String ?? ""
        self.highestBidderId = data["highestBidderId"] as? String ?? ""
        self.approved = data["approved"] as? Bool ?? false
        self.responded = data["responded"] as? Bool ?? false
        self.expired = data["expired"] as? Bool
        self.bidderIds = data["bidderIds"] as? [String] ?? []
    }
}
