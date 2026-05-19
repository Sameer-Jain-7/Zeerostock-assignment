//
//  UserAuctionViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 17/05/26.
//

import Foundation
import FirebaseFirestore

final class UserAuctionViewModel {

    // MARK: - Properties

    private(set) var auctions: [AuctionModel] = []
    private var listener: ListenerRegistration?

    // MARK: - Bindings

    var onLoading: ((Bool) -> Void)?
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    // MARK: - Observe Auctions

    func observeAuctions() {
        onLoading?(true)
        listener?.remove()
        listener = AuctionService.shared.observeApprovedAuctions {
            [weak self] result in

            self?.onLoading?(false)
            switch result {
            case .success(let auctions):
                self?.auctions = auctions.filter {
                    $0.expired != true
                }
                self?.onDataUpdated?()

            case .failure(let error):
                self?.onError?(
                    error.localizedDescription
                )
            }
        }
    }

    // MARK: - Cleanup

    deinit {
        listener?.remove()
    }
}
