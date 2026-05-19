//
//  UserTabBarController.swift
//  zeerostock
//
//  Created by Sameer Jain on 16/05/26.
//

import UIKit

final class UserTabBarController: BaseTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        
        let homeVC = UINavigationController(
            rootViewController: HomeViewController()
        )
        
        let auctionVC = UINavigationController(
            rootViewController: UserAuctionViewController()
        )
        
        let cartVC = UINavigationController(
            rootViewController: CartViewController()
        )
        
        let profileVC = UINavigationController(
            rootViewController: ProfileViewController()
        )
        
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        auctionVC.tabBarItem = UITabBarItem(
            title: "Auctions",
            image: UIImage(systemName: "hammer"),
            selectedImage: UIImage(systemName: "hammer.fill")
        )
        
        cartVC.tabBarItem = UITabBarItem(
            title: "Cart",
            image: UIImage(systemName: "cart"),
            selectedImage: UIImage(systemName: "cart.fill")
        )
        
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        viewControllers = [homeVC, auctionVC, cartVC, profileVC]
    }
}
