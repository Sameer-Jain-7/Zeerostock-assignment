//
//  AuctionService.swift
//  zeerostock
//
//  Created by Sameer Jain on 17/05/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class AuctionService {

    static let shared = AuctionService()
    private init() {}

    func autoRejectExpiredAuction(
        auction: AuctionModel
    ) {
        let endDate = auction.endTime.dateValue()
        guard endDate < Date(),
              auction.responded == false,
              auction.expired != true else {
            return
        }
        Firestore.firestore()
            .collection("auctions")
            .document(auction.id)
            .updateData([
                "approved": false,
                "responded": false,
                "expired": true
            ])
    }

    func createAuction(
        title: String,
        description: String,
        imageUrl: String,
        startingPrice: Double,
        endTime: Date,
        completion: @escaping(Result<Void, Error>) -> Void
    ) {

        guard let userId =
                Auth.auth().currentUser?.uid else {

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

        let auctionData: [String: Any] = [
            "title": title,
            "description": description,
            "imageUrl": imageUrl,
            "startingPrice": startingPrice,
            "currentBid": startingPrice,
            "currency": "INR",
            "createdBy": userId,
            "highestBidderId": "",
            "bidderIds": [],
            "endTime": Timestamp(date: endTime),
            "approved": false,
            "responded": false,
            "createdAt": Timestamp()
        ]

        Firestore.firestore()
            .collection("auctions")
            .addDocument(data: auctionData) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
    }

    func fetchAdminAuctions(
        completion: @escaping(Result<[AuctionModel], Error>) -> Void
    ) {

        Firestore.firestore()
            .collection("auctions")
            .order(by: "createdAt", descending: true)
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

                let auctions = documents.map {
                    AuctionModel(
                        id: $0.documentID,
                        data: $0.data()
                    )
                }
                completion(.success(auctions))
            }
    }

    func approveAuction(
        auctionId: String,
        completion: @escaping(Result<Void, Error>) -> Void
    ) {

        Firestore.firestore()
            .collection("auctions")
            .document(auctionId)
            .updateData([
                "approved": true,
                "responded": true
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
    }

    func rejectAuction(
        auctionId: String,
        completion: @escaping(Result<Void, Error>) -> Void
    ) {

        Firestore.firestore()
            .collection("auctions")
            .document(auctionId)
            .updateData([
                "approved": false,
                "responded": true
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
    }
    
    func fetchSupplierAuctions(
        completion: @escaping(Result<[AuctionModel], Error>) -> Void
    ) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.success([]))
            return
        }

        Firestore.firestore()
            .collection("auctions")
            .whereField("createdBy", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                let auctions = documents.map {
                    AuctionModel(
                        id: $0.documentID,
                        data: $0.data()
                    )
                }
                completion(.success(auctions))
            }
    }
    
    func observeApprovedAuctions(
        completion: @escaping(Result<[AuctionModel], Error>) -> Void
    ) -> ListenerRegistration {

        return Firestore.firestore()
            .collection("auctions")
            .whereField("approved", isEqualTo: true)
            .whereField("responded", isEqualTo: true)
            .addSnapshotListener { snapshot, error in

                if let error = error {

                    completion(.failure(error))

                    return
                }

                guard let documents =
                        snapshot?.documents else {

                    completion(.success([]))

                    return
                }

                let auctions = documents.map {

                    AuctionModel(
                        id: $0.documentID,
                        data: $0.data()
                    )
                }

                completion(.success(auctions))
            }
    }
}
