//
//  CartService.swift
//  zeerostock
//
//  Created by Sameer Jain on 18/05/26.
//

import Foundation

final class CartService {

    static let shared = CartService()

    private init() {

        loadCart()
    }

    private let cartKey = "cart_items"

    var items: [CartItemModel] = []

    // MARK: - Add To Cart

    func addToCart(
        product: ProductModel
    ) {

        if let index = items.firstIndex(
            where: { $0.product.id == product.id }
        ) {

            items[index].quantity += 1

        } else {

            let item = CartItemModel(
                product: product,
                quantity: 1
            )

            items.append(item)
        }

        saveCart()
    }

    // MARK: - Total

    func totalAmount() -> Double {

        items.reduce(0) {

            $0 + ($1.product.price * Double($1.quantity))
        }
    }

    // MARK: - Clear

    func clearCart() {

        items.removeAll()

        saveCart()
    }

    // MARK: - Save Cart

    private func saveCart() {

        do {

            let data =
            try JSONEncoder().encode(items)

            UserDefaults.standard.set(
                data,
                forKey: cartKey
            )

        } catch {

            print(error.localizedDescription)
        }
    }

    // MARK: - Load Cart

    private func loadCart() {

        guard let data =
                UserDefaults.standard.data(
                    forKey: cartKey
                ) else {

            return
        }

        do {

            items =
            try JSONDecoder().decode(
                [CartItemModel].self,
                from: data
            )

        } catch {

            print(error.localizedDescription)
        }
    }
    
    func increaseQuantity(
        productId: String
    ) {

        guard let index = items.firstIndex(
            where: {
                $0.product.id == productId
            }
        ) else {
            return
        }

        items[index].quantity += 1

        saveCart()
    }

    func decreaseQuantity(
        productId: String
    ) {

        guard let index = items.firstIndex(
            where: {
                $0.product.id == productId
            }
        ) else {
            return
        }

        items[index].quantity -= 1

        if items[index].quantity <= 0 {

            items.remove(at: index)
        }

        saveCart()
    }
}
