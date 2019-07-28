//
//  SignInViewController.swift
//  Instagram_ios
//
//  Created by Jane Shin on 7/27/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var customSignInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.backgroundColor = .clear
        emailTextField.tintColor = .darkGray
        emailTextField.textColor = .darkGray
        emailTextField.borderStyle = .none
        
        passwordTextField.backgroundColor = .clear
        passwordTextField.tintColor = .darkGray
        passwordTextField.textColor = .darkGray
        passwordTextField.borderStyle = .none
        
        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x: 0, y: 20, width: emailTextField.frame.width, height: 0.6)
        bottomLayerEmail.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        emailTextField.layer.addSublayer(bottomLayerEmail)
        
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 20, width: passwordTextField.frame.width, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        passwordTextField.layer.addSublayer(bottomLayerPassword)

        handleTextField()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil{
            self.performSegue(withIdentifier: "signInTabBarVC", sender: nil)
        }
    }

    func handleTextField(){
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(){
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else{
            customSignInButton.backgroundColor = .darkGray
            customSignInButton.isEnabled = false
            return
        }
        customSignInButton.backgroundColor = #colorLiteral(red: 0.9849042296, green: 0.7021037936, blue: 0, alpha: 0.6381635274)
        customSignInButton.isEnabled = true
    }
    
    @IBAction func signInButton_touchUpInside(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, err) in
            if err != nil{
                return
            }
            self.performSegue(withIdentifier: "signInTabBarVC", sender: nil)
        })
    }
    
}
