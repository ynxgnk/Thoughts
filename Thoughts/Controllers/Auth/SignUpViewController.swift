//
//  SignUpViewController.swift
//  Thoughts
//
//  Created by Nazar Kopeyka on 14.04.2023.
//

import UIKit

class SignUpViewController: UIViewController {

    //Header View
    private let headerView = SignInHeaderView() /* 373 copy from SignInViewController and paste */
    
    //Name field
    private let nameField: UITextField = { /* 373 */
        let field = UITextField() /* 373 */
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50)) /* 373 */
        field.leftViewMode = .always /* 373 */
        field.placeholder = "Full Name" /* 373 */
        field.autocorrectionType = .no /* 420 changed */
        field.backgroundColor = .secondarySystemBackground /* 373 */
        field.layer.cornerRadius = 8 /* 373 */
        field.layer.masksToBounds = true /* 373 */
        return field /* 373 */
    }()
    
    //Email field
    private let emailField: UITextField = { /* 373 */
        let field = UITextField() /* 373 */
        field.keyboardType = .emailAddress /* 373 */
        field.autocapitalizationType = .none /* 399 */
        field.autocorrectionType = .no /* 400 */
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50)) /* 373 */
        field.leftViewMode = .always /* 373 */
        field.placeholder = "Email Address" /* 373 */
        field.backgroundColor = .secondarySystemBackground /* 373 */
        field.layer.cornerRadius = 8 /* 373 */
        field.layer.masksToBounds = true /* 373 */
        return field /* 373 */
    }()
    
    //Password field
    private let passwordField: UITextField = { /* 373 */
        let field = UITextField() /* 373 */
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50)) /* 373 */
        field.leftViewMode = .always /* 373 */
        field.placeholder = "Password" /* 373 */
        field.autocapitalizationType = .none /* 401 */
        field.autocorrectionType = .no /* 402 */
        field.isSecureTextEntry = true /* 373 */
        field.backgroundColor = .secondarySystemBackground /* 373 */
        field.layer.cornerRadius = 8 /* 373 */
        field.layer.masksToBounds = true /* 373 */
        return field /* 373 */
    }()
    
    //Sign In Button
    private let signUpButton: UIButton = { /* 373 */
        let button = UIButton() /* 373 */
        button.backgroundColor = .systemGreen /* 373 */
        button.setTitle("Create Account", for: .normal) /* 373 */
        button.setTitleColor(.white, for: .normal) /* 373 */
        return button /* 373 */
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account" /* 106 */
        view.backgroundColor = .systemBackground /* 107 */
        view.addSubview(headerView) /* 373 */
        view.addSubview(nameField) /* 374 */
        view.addSubview(emailField) /* 373 */
        view.addSubview(passwordField) /* 373 */
        view.addSubview(signUpButton) /* 373 */
        
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside) /* 373 */
    }
    
    override func viewDidLayoutSubviews() { /* 373 */
        super.viewDidLayoutSubviews() /* 373 */
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/5) /* 373 */
        
        nameField.frame = CGRect(x: 20, y: headerView.bottom, width: view.width-40, height: 50) /* 375 */
        emailField.frame = CGRect(x: 20, y: nameField.bottom+10, width: view.width-40, height: 50) /* 373 */
        passwordField.frame = CGRect(x: 20, y: emailField.bottom+10, width: view.width-40, height: 50) /* 373 */
        signUpButton.frame = CGRect(x: 20, y: passwordField.bottom+10, width: view.width-40, height: 50) /* 373 */

    }
    
    @objc func didTapSignUp() { /* 373 */
        guard let email = emailField.text, !email.isEmpty, /* 377 */
              let password = passwordField.text, !password.isEmpty,
              let name = nameField.text, !name.isEmpty else {
            return /* 378 */
        }
        
        HapticsManager.shared.vibrateForSelection() /* 928 */
        
        //Create Account
        AuthManager.shared.signUp(email: email, password: password) { [weak self] success in /* 379 */ /* 387 add weak self */
            if success { /* 380 */
                //Update database
                let newUser = User(name: name, email: email, profilePictureRef: nil) /* 384 */
                DatabaseManager.shared.insert(user: newUser) { inserted in /* 383 */
                    guard inserted else { /* 385 */
                        return /* 386 */
                    }
                    
                    UserDefaults.standard.set(email, forKey: "email") /* 432 */
                    UserDefaults.standard.set(name, forKey: "name") /* 433 */
                    
                    DispatchQueue.main.async { /* 388 */
                        let vc = TabBarViewController() /* 389 */
                        vc.modalPresentationStyle = .fullScreen /* 390 */
                        self?.present(vc, animated: true) /* 391 */
                    }
                }
            } else { /* 381 */
                print("Failed to create account") /* 382 */
            }
        }
        //Update database
    }
}
