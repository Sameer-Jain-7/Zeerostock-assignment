//
//  BidService.swift
//  zeerostock
//
//  Created by Sameer Jain on 17/05/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class BidService {

    static let shared = BidService()

    private init() {}

    func placeBid(
        auction: AuctionModel,
        bidAmount: Double,
        completion: @escaping(Result<Void, Error>) -> Void
    ) {

        guard let userId = Auth.auth().currentUser?.uid else {
            completion(
                    .failure(
                        NSError(
                            domain: "",
                            code: 401,
                            userInfo: [
                                NSLocalizedDescriptionKey:
                                "User not logged in"
                            ]
                        )
                    )
                )
            return
        }

        // Validation

        guard bidAmount > auction.currentBid else {

            completion(
                .failure(
                    NSError(
                        domain: "",
                        code: 0,
                        userInfo: [
                            NSLocalizedDescriptionKey:
                            "Bid must be higher than current bid"
                        ]
                    )
                )
            )

            return
        }

        Firestore.firestore()
            .collection("auctions")
            .document(auction.id)
            .updateData([

                "currentBid": bidAmount,
                "highestBidderId": userId,
                "bidderIds": FieldValue.arrayUnion([userId])

            ]) { error in

                if let error = error {

                    completion(.failure(error))
                    return
                }

                completion(.success(()))
            }
    }
}
