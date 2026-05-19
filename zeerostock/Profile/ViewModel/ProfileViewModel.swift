//
//  ProfileViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 19/05/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class ProfileViewModel {

    private var auctionListener: ListenerRegistration?

    var onLoading: ((Bool) -> Void)?
    var onAuctionStatsUpdated: ((Int, Int) -> Void)?
    var onLogoutSuccess: (() -> Void)?
    var onError: ((String) -> Void)?

    var userName: String {
        let user = Auth.auth().currentUser

        return user?.displayName?.isEmpty == false
        ? user?.displayName ?? ""
        : "ZeeroStock User"
    }

    var userEmail: String {
        Auth.auth().currentUser?.email ?? ""
    }

    var roleText: String {
        RoleManager.shared.currentRole
            .replacingOccurrences(of: "_", with: " ")
            .capitalized
    }

    var isUser: Bool {
        RoleManager.shared.currentRole == "user"
    }

    func fetchAuctionActivity() {

        onLoading?(true)

        auctionListener = ProfileService.shared
            .observeAuctionActivity { [weak self] result in

                self?.onLoading?(false)

                switch result {

                case .success(let stats):

                    self?.onAuctionStatsUpdated?(
                        stats.won,
                        stats.leading
                    )

                case .failure(let error):

                    self?.onError?(error.localizedDescription)
                }
            }
    }

    func logout() {

        ProfileService.shared.logout {
            [weak self] result in

            switch result {

            case .success:

                RoleManager.shared.currentRole = ""

                self?.onLogoutSuccess?()

            case .failure(let error):

                self?.onError?(error.localizedDescription)
            }
        }
    }

    deinit {
        auctionListener?.remove()
    }
}
