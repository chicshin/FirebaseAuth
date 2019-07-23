//
//  ViewController.swift
//  ChicshinFirebaseFacebookAuth
//
//  Created by Jane Shin on 7/21/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, LoginButtonDelegate  {
    

    @IBOutlet weak var facebookLoginButton: FBLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        facebookLoginButton.delegate = self
        
    }
    
    func loginButton(_ loginButton: FBLoginButton!, didCompleteWith result: LoginManagerLoginResult?, error: Error!) {

        if(result?.token == nil) { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                return
            }
            // User is signed in
            // ...
        }
        LoginManager().logOut();
    
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {

    }


}

