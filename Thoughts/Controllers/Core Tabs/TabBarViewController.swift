//
//  TabBarViewController.swift
//  Thoughts
//
//  Created by Nazar Kopeyka on 14.04.2023.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() { /* 9 */
        super.viewDidLoad() /* 10 */
        
        setUpControllers() /* 23 */
    }
    
    private func setUpControllers() { /* 11 */
        guard let currentUserEmail = UserDefaults.standard.string(forKey: "email") else { /* 463 */
            return /* 464 */
        }
                
        let home = HomeViewController() /* 12 */
        home.title = "Home" /* 13 */
        let profile = ProfileViewController(currentEmail: currentUserEmail) /* 14 */ /* 465 add currentEmail */
        profile.title = "Profile" /* 15 */
        
        home.navigationItem.largeTitleDisplayMode = .always /* 16 */
        profile.navigationItem.largeTitleDisplayMode = .always /* 17 */
        
        let nav1 = UINavigationController(rootViewController: home) /* 18 */
        let nav2 = UINavigationController(rootViewController: profile) /* 19 */
        
        nav1.navigationBar.prefersLargeTitles = true /* 20 */
        nav2.navigationBar.prefersLargeTitles = true /* 21 */
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1) /* 24 */
        nav2.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2) /* 25 */
        
        setViewControllers([nav1, nav2], animated: true) /* 22 */
    }
}
