//
//  HomeViewController.swift
//  Instagram_ios
//
//  Created by Jane Shin on 7/27/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadPosts()
    }
    
    func loadPosts(){
        Database.database().reference().child("posts").observe(.childAdded, with: { (snapshot: DataSnapshot) in
            print(snapshot.value)
        })
    }
    @IBAction func logOut_touchUpInside(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let logutError {
            print(logutError)
        }
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
    }

}

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.backgroundColor = .orange
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    
}
