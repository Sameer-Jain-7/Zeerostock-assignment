//
//  CartViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 19/05/26.
//

import Foundation

final class CartViewModel {

    private(set) var items: [CartItemModel] = []

    var onDataUpdated: (() -> Void)?
    var onLoading: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    var onOrderPlaced: (() -> Void)?

    func fetchCartItems() {
        items = CartService.shared.items
        onDataUpdated?()
    }

    func numberOfItems() -> Int {
        items.count
    }

    func item(at index: Int) -> CartItemModel {
        items[index]
    }

    func increaseQuantity(productId: String) {
        CartService.shared.increaseQuantity(productId: productId)
        fetchCartItems()
    }

    func decreaseQuantity(productId: String) {
        CartService.shared.decreaseQuantity(productId: productId)
        fetchCartItems()
    }

    func totalAmount() -> Double {
        CartService.shared.totalAmount()
    }

    func isCartEmpty() -> Bool {
        items.isEmpty
    }

    func checkout() {

        onLoading?(true)

        OrderService.shared.createOrder(
            items: items
        ) { [weak self] result in

            DispatchQueue.main.async {

                self?.onLoading?(false)

                switch result {

                case .success:

                    CartService.shared.clearCart()

                    self?.fetchCartItems()

                    self?.onOrderPlaced?()

                case .failure(let error):

                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
}
