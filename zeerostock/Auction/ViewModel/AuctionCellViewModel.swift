//
//  AuctionCellViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 19/05/26.
//

import Foundation
import UIKit
internal import FirebaseCore

struct AuctionCellViewModel {

    private let auction: AuctionModel

    init(auction: AuctionModel) {
        self.auction = auction
    }

    var titleText: String {
        auction.title
    }

    var priceText: String {
        "Highest Bid: ₹\(String(format: "%.2f", auction.currentBid))"
    }

    var statusText: String {

        let endDate = auction.endTime.dateValue()

        if auction.expired == true {
            return "Approval Expired"
        }

        if !auction.responded {
            return "Pending Approval"
        }

        if auction.approved {

            if endDate < Date() {
                return "Auction Ended"
            }

            return "Live Auction"
        }

        return "Rejected"
    }

    var statusColor: UIColor {

        let endDate = auction.endTime.dateValue()

        if auction.expired == true {
            return .systemGray
        }

        if !auction.responded {
            return .systemOrange
        }

        if auction.approved {

            if endDate < Date() {
                return .systemGray
            }

            return .systemGreen
        }

        return .systemRed
    }

    var statusBackgroundColor: UIColor {

        switch statusColor {

        case .systemGreen:
            return UIColor.systemGreen.withAlphaComponent(0.12)

        case .systemOrange:
            return UIColor.systemOrange.withAlphaComponent(0.12)

        case .systemRed:
            return UIColor.systemRed.withAlphaComponent(0.12)

        default:
            return UIColor.systemGray.withAlphaComponent(0.12)
        }
    }

    var imageURL: URL? {
        URL(string: auction.imageUrl)
    }
}
