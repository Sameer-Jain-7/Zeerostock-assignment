//
//  AdminAuctionViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 17/05/26.
//

import Foundation

final class AdminAuctionViewModel {

    private(set) var auctions: [AuctionModel] = []

    var onLoading: ((Bool) -> Void)?
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    func fetchAuctions() {

        onLoading?(true)

        AuctionService.shared.fetchAdminAuctions {
            [weak self] result in

            self?.onLoading?(false)

            switch result {

            case .success(let auctions):

                auctions.forEach {

                    AuctionService.shared
                        .autoRejectExpiredAuction(
                            auction: $0
                        )
                }

                self?.auctions = auctions

                self?.onDataUpdated?()

            case .failure(let error):

                self?.onError?(
                    error.localizedDescription
                )
            }
        }
    }

    func approveAuction(
        auctionId: String
    ) {

        guard RoleManager.shared
            .canManageAuctions else {
            return
        }

        AuctionService.shared.approveAuction(
            auctionId: auctionId
        ) { [weak self] result in

            switch result {

            case .success:

                self?.fetchAuctions()

            case .failure(let error):

                self?.onError?(
                    error.localizedDescription
                )
            }
        }
    }

    func rejectAuction(
        auctionId: String
    ) {

        guard RoleManager.shared
            .canManageAuctions else {
            return
        }

        AuctionService.shared.rejectAuction(
            auctionId: auctionId
        ) { [weak self] result in

            switch result {

            case .success:

                self?.fetchAuctions()

            case .failure(let error):

                self?.onError?(
                    error.localizedDescription
                )
            }
        }
    }
}

// admin email - Zeero.admin@gmail.com
// admin password - qwe123
