//
//  PayWallViewController.swift
//  Thoughts
//
//  Created by Nazar Kopeyka on 15.04.2023.
//

import UIKit

class PayWallViewController: UIViewController {

    private let header = PayWallHeaderView() /* 148 */
    //Close button / Title
    //Pricing and product info
    private let heroView = PayWallDescriptionView() /* 228 */
    
    //Called Action Button
    private let buyButton: UIButton = { /* 168 */
        let button = UIButton() /* 169 */
        button.setTitle("Subscribe", for: .normal) /* 170 */
        button.backgroundColor = .systemBlue /* 171 */
        button.setTitleColor(.white, for: .normal) /* 172 */
        button.layer.cornerRadius = 8 /* 173 */
        button.layer.masksToBounds = true /* 174 */
        return button /* 175 */
    }()
    
    private let restoreButton: UIButton = { /* 176 */
        let button = UIButton() /* 177 */
        button.setTitle("Restore Purchases", for: .normal) /* 178 */
        button.setTitleColor(.link, for: .normal) /* 179 */
        button.layer.cornerRadius = 8 /* 180 */
        button.layer.masksToBounds = true /* 181 */
        return button /* 182 */
    }()
    
    //Terms of Service
    private let termsView: UITextView = { /* 191 */
        let textView = UITextView() /* 192 */
        textView.isEditable = false /* 193 */
        textView.textAlignment = .center /* 194 */
        textView.textColor = .secondaryLabel /* 200 */
        textView.font = .systemFont(ofSize: 14) /* 195 */
        textView.text = "This is an auto-renewable Subscription. It will be charged to your iTunes account before each pay period. You can cancel anytime by going into your Settings > Subscriptions. Restore purchases if previously subscribed." /* 196 */
        return textView /* 197 */
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Thoughts Premium" /* 167 */
        view.backgroundColor = .systemBackground /* 117 */
        view.addSubview(header) /* 149 */
        view.addSubview(buyButton) /* 183 */
        view.addSubview(restoreButton) /* 184 */
        view.addSubview(termsView) /* 198 */
        view.addSubview(heroView) /* 229 */
        setUpCloseButton() /* 134 */
        setUpButtons() /* 186 */
//        heroView.backgroundColor = .systemYellow /* 231 */
    }
    
    override func viewDidLayoutSubviews() { /* 150 */
        super.viewDidLayoutSubviews() /* 151 */
        header.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: view.height / 3.2
        ) /* 166 */
        
        termsView.frame = CGRect(
            x: 10,
            y: view.height - 120,
            width: view.width - 20,
            height: 100
        ) /* 199 */
        
        restoreButton.frame = CGRect(
            x: 25,
            y: termsView.top - 70,
            width: view.width - 50,
            height: 50
        ) /* 201 */
        
        buyButton.frame = CGRect(
            x: 25,
            y: restoreButton.top - 60,
            width: view.width - 50,
            height: 50
        ) /* 202 */
        
        heroView.frame = CGRect(
            x: 0,
            y: header.bottom,
            width: view.width,
            height: buyButton.top - view.safeAreaInsets.top - header.height
        ) /* 230 */
    }
    
    private func setUpButtons() { /* 185 */
        buyButton.addTarget(self, action: #selector(didTapSubscribe), for: .touchUpInside) /* 189 */
        restoreButton.addTarget(self, action: #selector(didTapRestore), for: .touchUpInside) /* 190 */
    }
    
    @objc private func didTapSubscribe() { /* 187 */
        IAPManager.shared.fetchPackages { package in /* 285 */
            guard let package = package else { return } /* 286 */
            IAPManager.shared.subscribe(package: package) { [weak self] success in /* 287 */ /* 292 add weak self */
                print("Purchase: \(success)") /* 288 */
                DispatchQueue.main.async { /* 289 */
                    if success { /* 290 */
                        self?.dismiss(animated: true, completion: nil) /* 291 */
                    } else { /* 292 */
                        let alert = UIAlertController(
                            title: "Subscription Failed",
                            message: "We were unable to complete the transaction.",
                            preferredStyle: .alert
                        ) /* 293 */
                        alert.addAction(UIAlertAction(
                            title: "Dismiss",
                            style: .cancel,
                            handler: nil)
                        ) /* 295 */ 
                        self?.present(alert, animated: true, completion: nil) /* 294 */
                    }
                }
            }
        }
    }
    
    /* IAPManager.shared.fetchPackages { package in /* 258 */
     guard let package = package else { /* 259 */
         return /* 260 */
     }
     print("Got package!") /* 261 */
     IAPManager.shared.subscribe(package: package) { success in /* 262 */
         print("Success: \(success)") /* 279 */
     }
 }
     */
    
    @objc private func didTapRestore() { /* 188 */
        IAPManager.shared.restorePurchases { [weak self] success in /* 296 */
            print("Restored: \(success)") /* 297 copy from didTapSubscribe 187 */
            DispatchQueue.main.async { /* 297 */
                if success { /* 297 */
                    self?.dismiss(animated: true, completion: nil) /* 297 */
                } else { /* 297 */
                    let alert = UIAlertController(
                        title: "Restoration Failed",
                        message: "We were unable to restore a previous transaction.",
                        preferredStyle: .alert
                    ) /* 297 */
                    alert.addAction(UIAlertAction(
                        title: "Dismiss",
                        style: .cancel,
                        handler: nil)
                    ) /* 297 */
                    self?.present(alert, animated: true, completion: nil) /* 297 */
                }
            }
        }
    }
    
    private func setUpCloseButton() { /* 132 */
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        ) /* 133 */
    }
    
    @objc private func didTapClose() { /* 131 */
        dismiss(animated: true, completion: nil) /* 135 */
    }
    

}
