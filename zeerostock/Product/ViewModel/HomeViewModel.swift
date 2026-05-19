//
//  HomeViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 16/05/26.
//

import Foundation

final class HomeViewModel {

    private(set) var products: [ProductModel] = []

    var onLoading: ((Bool) -> Void)?
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    func fetchProducts() {

        onLoading?(true)

        ProductService.shared.fetchApprovedProducts {
            [weak self] result in

            self?.onLoading?(false)

            switch result {

            case .success(let products):

                self?.products = products
                self?.onDataUpdated?()

            case .failure(let error):

                self?.onError?(
                    error.localizedDescription
                )
            }
        }
    }
}
