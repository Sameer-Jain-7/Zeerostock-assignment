//
//  SupplierTabBarController.swift
//  zeerostock
//
//  Created by Sameer Jain on 16/05/26.
//

import UIKit

final class SupplierTabBarController: BaseTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        
        let productsVC = UINavigationController(
            rootViewController: SupplierProductsViewController()
        )
        
        let auctionsVC = UINavigationController(
            rootViewController: SupplierAuctionsViewController()
        )
        
        let addProductVC = UINavigationController(
            rootViewController: AddProductViewController()
        )
        
        let addAuctionVC = UINavigationController(
            rootViewController: AddAuctionViewController()
        )
        
        let profileVC = UINavigationController(
            rootViewController: ProfileViewController()
        )
        
        productsVC.tabBarItem = UITabBarItem(
            title: "Products",
            image: UIImage(systemName: "bag"),
            selectedImage: UIImage(systemName: "bag.fill")
        )
        
        auctionsVC.tabBarItem = UITabBarItem(
            title: "Auctions",
            image: UIImage(systemName: "hammer"),
            selectedImage: UIImage(systemName: "hammer.fill")
        )
        
        addProductVC.tabBarItem = UITabBarItem(
            title: "Add Item",
            image: UIImage(systemName: "bag.badge.plus"),
            selectedImage: UIImage(systemName: "bag.fill.badge.plus")
        )
        
        addAuctionVC.tabBarItem = UITabBarItem(
            title: "Add Bid",
            image: UIImage(systemName: "plus.circle"),
            selectedImage: UIImage(systemName: "plus.circle.fill")
        )
        
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        viewControllers = [productsVC, auctionsVC, addProductVC, addAuctionVC, profileVC]
    }
}
