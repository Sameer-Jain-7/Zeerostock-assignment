//
//  ProfileService.swift
//  zeerostock
//
//  Created by Sameer Jain on 19/05/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class ProfileService {

    static let shared = ProfileService()

    private init() {}

    func observeAuctionActivity(
        completion: @escaping(Result<(won: Int, leading: Int), Error>) -> Void
    ) -> ListenerRegistration? {

        guard let userId = Auth.auth().currentUser?.uid else {
            return nil
        }

        return Firestore.firestore()
            .collection("auctions")
            .addSnapshotListener { snapshot, error in

                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(.success((0,0)))
                    return
                }

                let auctions = documents.map {
                    AuctionModel(
                        id: $0.documentID,
                        data: $0.data()
                    )
                }

                let wonAuctions = auctions.filter {
                    $0.highestBidderId == userId &&
                    $0.endTime.dateValue() < Date() &&
                    $0.approved
                }

                let leadingAuctions = auctions.filter {
                    $0.highestBidderId == userId &&
                    $0.endTime.dateValue() > Date() &&
                    $0.approved
                }

                completion(.success((
                    won: wonAuctions.count,
                    leading: leadingAuctions.count
                )))
            }
    }

    func logout(
        completion: @escaping(Result<Void, Error>) -> Void
    ) {

        do {

            try Auth.auth().signOut()

            completion(.success(()))

        } catch {

            completion(.failure(error))
        }
    }
}
