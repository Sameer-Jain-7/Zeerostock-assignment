//
//  OrderService.swift
//  zeerostock
//
//  Created by Sameer Jain on 18/05/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class OrderService {

    static let shared = OrderService()

    private init() {}

    func createOrder(
        items: [CartItemModel],
        completion: ((Result<Void, Error>) -> Void)? = nil
    ) {

        guard let userId =
                Auth.auth().currentUser?.uid else {
            return
        }

        let totalAmount = items.reduce(0) {

            $0 + (
                $1.product.price *
                Double($1.quantity)
            )
        }

        let orderItems: [[String: Any]] = items.map {

            [
                "title": $0.product.title,
                "quantity": $0.quantity,
                "price": $0.product.price,
                "imageUrl": $0.product.imageUrl
            ]
        }

        let data: [String: Any] = [
            "userId": userId,
            "totalAmount": totalAmount,
            "createdAt": Timestamp(),
            "order_items": orderItems
        ]

        Firestore.firestore()
            .collection("orders")
            .addDocument(data: data) { error in

                if let error = error {

                    completion?(.failure(error))
                    return
                }

                completion?(.success(()))
            }
    }

    func fetchOrders(
        completion: @escaping(Result<[OrderModel], Error>) -> Void
    ) {

        guard let userId =
                Auth.auth().currentUser?.uid else {

            completion(.success([]))
            return
        }

        Firestore.firestore()
            .collection("orders")
            .whereField(
                "userId",
                isEqualTo: userId
            )
            .order(
                by: "createdAt",
                descending: true
            )
            .getDocuments { snapshot, error in

                if let error = error {

                    completion(.failure(error))
                    return
                }

                guard let documents =
                        snapshot?.documents else {

                    completion(.success([]))
                    return
                }

                let orders = documents.map {

                    OrderModel(
                        id: $0.documentID,
                        data: $0.data()
                    )
                }

                completion(.success(orders))
            }
    }
}
