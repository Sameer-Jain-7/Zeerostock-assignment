//
//  AddAuctionViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 17/05/26.
//

import Foundation

final class AddAuctionViewModel {

    // MARK: - Bindings

    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoading: ((Bool) -> Void)?

    // MARK: - Form Fields

    var title: String = ""
    var description: String = ""
    var imageUrl: String = ""
    var startingPriceText: String = ""
    var endDate: Date = Date()

    // MARK: - Validation

    private func validateFields() -> Double? {

        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            onError?("Please enter title")
            return nil
        }

        if description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            onError?("Please enter description")
            return nil
        }

        if imageUrl.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            onError?("Please enter image URL")
            return nil
        }

        guard let price = Double(startingPriceText) else {
            onError?("Please enter valid price")
            return nil
        }

        if price <= 0 {
            onError?("Price should be greater than 0")
            return nil
        }

        return price
    }

    // MARK: - Create Auction

    func createAuction() {

        guard let startingPrice = validateFields() else {
            return
        }

        onLoading?(true)

        AuctionService.shared.createAuction(
            title: title,
            description: description,
            imageUrl: imageUrl,
            startingPrice: startingPrice,
            endTime: endDate
        ) { [weak self] result in

            self?.onLoading?(false)

            switch result {

            case .success:
                self?.onSuccess?()

            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
}
