//
//  AdminUserListViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 17/05/26.
//

import Foundation

final class AdminUserListViewModel {

    private(set) var users: [UserDataModel] = []

    var onLoading: ((Bool) -> Void)?
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    func fetchUsers() {

        onLoading?(true)

        UserService.shared.fetchUsers {
            [weak self] result in

            self?.onLoading?(false)

            switch result {

            case .success(let users):

                self?.users = users

                self?.onDataUpdated?()

            case .failure(let error):

                self?.onError?(
                    error.localizedDescription
                )
            }
        }
    }
}
