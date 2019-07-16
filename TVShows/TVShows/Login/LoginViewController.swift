//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 07/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    //MARK: - Outlets
   
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    //MARK: - Properties
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
        
        loginButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    
    //MARK: - Actions
    
    @IBAction func checkboxTouched(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }

    @IBAction func navigateToHomeLoginButton() {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let HomeViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
    
        navigationController?.pushViewController(HomeViewController, animated: true)
    }
    
    @IBAction func navigateToHomeCreateButton() {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let HomeViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        
        navigationController?.pushViewController(HomeViewController, animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
    }

}
