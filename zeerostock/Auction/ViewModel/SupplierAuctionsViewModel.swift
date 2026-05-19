//
//  SupplierAuctionsViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 17/05/26.
//

import Foundation

final class SupplierAuctionsViewModel {

    private(set) var auctions: [AuctionModel] = []

    var onLoading: ((Bool) -> Void)?
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func fetchAuctions() {
        onLoading?(true)
        AuctionService.shared.fetchSupplierAuctions {
            [weak self] result in
            self?.onLoading?(false)
            
            switch result {
                
            case .success(let auctions):
                self?.auctions = auctions
                self?.onDataUpdated?()
                
            case .failure(let error):
                self?.onError?(
                    error.localizedDescription
                )
            }
        }
    }
}
