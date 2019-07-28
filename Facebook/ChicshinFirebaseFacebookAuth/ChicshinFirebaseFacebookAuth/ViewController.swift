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
    
    var remoteConfg : RemoteConfig!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        remoteConfg = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfg.configSettings = settings
        remoteConfg.setDefaults(fromPlist: "FireSwiftRemoteConfigDefaults")
        
        remoteConfg.fetch(withExpirationDuration: TimeInterval(0)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched")
                self.remoteConfg.activate(completionHandler: { (error) in
                    
                })
            }else {
                print("Config not fetched")
            }
            self.displayMessage()
        
        }
        
        facebookLoginButton.delegate = self
        
        Auth.auth().addStateDidChangeListener({ (user, err) in
            
            if(user != nil){
                self.performSegue(withIdentifier: "Home", sender: nil)
            }
        })
        
        
    }
    
    func displayMessage(){
        
        let message = remoteConfg["welcome_message"].stringValue
        let caps = remoteConfg["welcome_message_caps"].boolValue
        let color = remoteConfg["backgroundColor"].numberValue
        
        if(caps){
            print("remote activated")
            let alert = UIAlertController(title: "Notice", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (action) in
                exit(0)
            }))
            self.dismiss(animated: true) { () -> Void in
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            self.performSegue(withIdentifier: "Home", sender: nil)
        }
        if(color == 1){
            self.view.backgroundColor = UIColor.gray
        }
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

