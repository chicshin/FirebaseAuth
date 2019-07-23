//
//  UserController.swift
//  ChicshinFirebaseFacebookAuth
//
//  Created by Jane Shin on 7/23/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase

class UserController: UIViewController {

    @IBAction func signout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
        }
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
