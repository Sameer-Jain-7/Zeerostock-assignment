//
//  AdminTabBarController.swift
//  zeerostock
//
//  Created by Sameer Jain on 17/05/26.
//

import UIKit

final class AdminTabBarController: BaseTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {

        var controllers: [UIViewController] = []

        if RoleManager.shared.canManageProducts {

            let productsVC = UINavigationController(
                rootViewController: AdminApprovalViewController()
            )

            productsVC.tabBarItem = UITabBarItem(
                title: "Products",
                image: UIImage(systemName: "shippingbox"),
                selectedImage: UIImage(systemName: "shippingbox.fill")
            )

            controllers.append(productsVC)
        }

        if RoleManager.shared.canManageAuctions {

            let auctionsVC = UINavigationController(
                rootViewController: AdminAuctionViewController()
            )

            auctionsVC.tabBarItem = UITabBarItem(
                title: "Auctions",
                image: UIImage(systemName: "hammer"),
                selectedImage: UIImage(systemName: "hammer.fill")
            )

            controllers.append(auctionsVC)
        }

        let usersVC = UINavigationController(
            rootViewController: AdminUserListViewController()
        )

        usersVC.tabBarItem = UITabBarItem(
            title: "Users",
            image: UIImage(systemName: "person.3"),
            selectedImage: UIImage(systemName: "person.3.fill")
        )

        controllers.append(usersVC)
        
        let profileVC = UINavigationController(
            rootViewController: ProfileViewController()
        )

        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )

        controllers.append(profileVC)

        viewControllers = controllers
    }
}
