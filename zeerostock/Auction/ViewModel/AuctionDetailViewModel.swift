//
//  AuctionDetailViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 19/05/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import UIKit

final class AuctionDetailViewModel {

    // MARK: - Properties

    private(set) var auction: AuctionModel
    private var listener: ListenerRegistration?

    // MARK: - Bindings

    var onAuctionUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onBidPlaced: (() -> Void)?
    var onAuctionApproved: (() -> Void)?
    var onAuctionRejected: (() -> Void)?

    // MARK: - Init

    init(auction: AuctionModel) {
        self.auction = auction
    }

    // MARK: - UI Data

    var titleText: String {
        auction.title
    }

    var descriptionText: String {
        auction.description
    }

    var currentBidText: String {
        "Highest Bid: ₹\(String(format: "%.2f", auction.currentBid))"
    }

    var endTimeText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        return "Ends: \(formatter.string(from: auction.endTime.dateValue()))"
    }

    var imageURL: URL? {
        URL(string: auction.imageUrl)
    }

    // MARK: - Countdown

    var countdownText: String {

        let remaining = Int(auction.endTime.dateValue().timeIntervalSinceNow)

        if remaining <= 0 {
            return "Auction Ended"
        }

        let hours = remaining / 3600
        let minutes = (remaining % 3600) / 60
        let seconds = remaining % 60

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    var isAuctionEnded: Bool {
        auction.endTime.dateValue() < Date()
    }

    var shouldHideCountdown: Bool {
        auction.responded && !auction.approved
    }

    // MARK: - Bid Status

    var bidStatusText: String {

        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return ""
        }

        if isAuctionEnded {

            if auction.highestBidderId == currentUserId {
                return "Congratulations! You won this auction"
            } else {
                return "No Bidding Allowed. Auction has Ended"
            }
        }

        if auction.highestBidderId == currentUserId {
            return "You are currently the highest bidder"
        } else if auction.bidderIds.contains(currentUserId) {
            return "You have been outbid"
        } else if auction.bidderIds.isEmpty {
            return "No bids placed yet"
        } else {
            return "No Bids placed by you"
        }
    }

    var bidStatusColor: UIColor {

        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return .systemGray
        }

        if isAuctionEnded {
            return auction.highestBidderId == currentUserId ? .systemGreen : .systemGray
        }

        if auction.highestBidderId == currentUserId {
            return .systemGreen
        } else if auction.bidderIds.contains(currentUserId) {
            return .systemRed
        } else if auction.bidderIds.isEmpty {
            return .systemOrange
        } else {
            return .systemRed
        }
    }

    // MARK: - Button State

    var isBiddingEnabled: Bool {
        !isAuctionEnded
    }

    // MARK: - Observe Auction

    func observeAuction() {

        listener = Firestore.firestore()
            .collection("auctions")
            .document(auction.id)
            .addSnapshotListener { [weak self] snapshot, error in

                if let error = error {
                    self?.onError?(error.localizedDescription)
                    return
                }

                guard let data = snapshot?.data(),
                      let documentId = snapshot?.documentID else {
                    return
                }

                self?.auction = AuctionModel(id: documentId, data: data)
                self?.onAuctionUpdated?()
            }
    }

    // MARK: - Place Bid

    func placeBid(amountText: String?) {

        guard let text = amountText,
              let amount = Double(text) else {
            onError?("Enter valid bid amount")
            return
        }

        BidService.shared.placeBid(
            auction: auction,
            bidAmount: amount
        ) { [weak self] result in

            switch result {

            case .success:
                self?.onBidPlaced?()

            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }

    // MARK: - Approve Auction

    func approveAuction() {

        Firestore.firestore()
            .collection("auctions")
            .document(auction.id)
            .updateData([
                "approved": true,
                "responded": true
            ]) { [weak self] error in

                if let error = error {
                    self?.onError?(error.localizedDescription)
                    return
                }

                self?.onAuctionApproved?()
            }
    }

    // MARK: - Reject Auction

    func rejectAuction() {

        Firestore.firestore()
            .collection("auctions")
            .document(auction.id)
            .updateData([
                "approved": false,
                "responded": true
            ]) { [weak self] error in

                if let error = error {
                    self?.onError?(error.localizedDescription)
                    return
                }

                self?.onAuctionRejected?()
            }
    }

    // MARK: - Cleanup

    deinit {
        listener?.remove()
    }
}
