//
//  UserOrdersViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 19/05/26.
//

import Foundation

final class UserOrdersViewModel {

    private(set) var orders: [OrderModel] = []

    var onLoading: ((Bool) -> Void)?
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    func fetchOrders() {

        onLoading?(true)

        OrderService.shared.fetchOrders {
            [weak self] result in

            self?.onLoading?(false)

            switch result {

            case .success(let orders):

                self?.orders = orders

                self?.onDataUpdated?()

            case .failure(let error):

                self?.onError?(
                    error.localizedDescription
                )
            }
        }
    }
}
