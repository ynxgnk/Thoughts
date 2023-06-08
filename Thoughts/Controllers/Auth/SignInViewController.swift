//
//  SignInViewController.swift
//  Thoughts
//
//  Created by Nazar Kopeyka on 14.04.2023.
//

import UIKit

class SignInViewController: UIViewController {

    //Header View
    private let headerView = SignInHeaderView() /* 322 */
    
    //Email field
    private let emailField: UITextField = { /* 327 */
        let field = UITextField() /* 328 */
        field.keyboardType = .emailAddress /* 329 */
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50)) /* 330 */
        field.leftViewMode = .always /* 368 */
        field.placeholder = "Email Address" /* 331 */
        field.autocapitalizationType = .none /* 405 */
        field.autocorrectionType = .no /* 406 */
        field.backgroundColor = .secondarySystemBackground /* 332 */
        field.layer.cornerRadius = 8 /* 333 */
        field.layer.masksToBounds = true /* 334 */
        return field /* 335 */
    }()
    
    //Password field
    private let passwordField: UITextField = { /* 336 */
        let field = UITextField() /* 337 */
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50)) /* 338 */
        field.leftViewMode = .always /* 369 */
        field.placeholder = "Password" /* 339 */
        field.autocapitalizationType = .none /* 403 */
        field.autocorrectionType = .no /* 404 */
        field.isSecureTextEntry = true /* 340 */
        field.backgroundColor = .secondarySystemBackground /* 341 */
        field.layer.cornerRadius = 8 /* 342 */
        field.layer.masksToBounds = true /* 343 */
        return field /* 344 */
    }()
    
    //Sign In Button
    private let signInButton: UIButton = { /* 345 */
        let button = UIButton() /* 346 */
        button.backgroundColor = .systemBlue /* 347 */
        button.setTitle("Sign In", for: .normal) /* 348 */
        button.setTitleColor(.white, for: .normal) /* 349 */
        return button /* 350 */
    }()
    
    //Create Account
    private let createAccountButton: UIButton = { /* 251 */
        let button = UIButton() /* 352 */
        button.setTitle("Create Account", for: .normal) /* 353 */
        button.setTitleColor(.link, for: .normal) /* 354 */
        return button /* 355 */
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In" /* 104 */
        view.backgroundColor = .systemBackground /* 105 */
        view.addSubview(headerView) /* 323 */
        view.addSubview(emailField) /* 356 */
        view.addSubview(passwordField) /* 357 */
        view.addSubview(signInButton) /* 358 */
        view.addSubview(createAccountButton) /* 359 */
        
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside) /* 362 */
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside) /* 363 */
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+3) { /* 120 */
//            if !IAPManager.shared.isPremium() { /* 121 */
//                let vc = PayWallViewController() /* 122 */
//                let navVC = UINavigationController(rootViewController: vc) /* 129 */
//                self.present(navVC, animated: true, completion: nil) /* 123 */ /* 130 change vc to navVC */
//            }
//        }
    }
    
    override func viewDidLayoutSubviews() { /* 324 */
        super.viewDidLayoutSubviews() /* 325 */
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/5) /* 326 */
        
        emailField.frame = CGRect(x: 20, y: headerView.bottom, width: view.width-40, height: 50) /* 364 */
        passwordField.frame = CGRect(x: 20, y: emailField.bottom+10, width: view.width-40, height: 50) /* 365 */
        signInButton.frame = CGRect(x: 20, y: passwordField.bottom+10, width: view.width-40, height: 50) /* 366 */
        createAccountButton.frame = CGRect(x: 20, y: signInButton.bottom+40, width: view.width-40, height: 50) /* 367 */

    }
    
    @objc func didTapSignIn() { /* 360 */
        guard let email = emailField.text, !email.isEmpty, let password = passwordField.text,
              !password.isEmpty else { /* 421 */
            return /* 422 */
        }
        
        HapticsManager.shared.vibrateForSelection() /* 927 */
        
        AuthManager.shared.signIn(email: email, password: password) { [weak self] success in /* 423 */ /* 428 add weak self */
            guard success else { /* 429 */
                return /* 430 */
            }
            
            //Update subscription status for newly signed user
            IAPManager.shared.getSubscriptionStatus(completion: nil) /* 904 */
            
            DispatchQueue.main.async { /* 424 */
                UserDefaults.standard.set(email, forKey: "email") /* 431 */ 
                let vc = TabBarViewController() /* 425 */
                vc.modalPresentationStyle = .fullScreen /* 426 */
                self?.present(vc, animated: true) /* 427 */
            }
        }
    }
    
    @objc func didTapCreateAccount() { /* 361 */
        let vc = SignUpViewController() /* 370 */
        vc.title = "Create Account" /* 371 */
        vc.navigationItem.largeTitleDisplayMode = .never /* 376 */
        navigationController?.pushViewController(vc, animated: true) /* 372 */
    }
}
