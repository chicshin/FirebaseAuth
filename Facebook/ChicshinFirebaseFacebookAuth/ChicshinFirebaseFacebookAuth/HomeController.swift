//
//  HomeController.swift
//  ChicshinFirebaseFacebookAuth
//
//  Created by Jane Shin on 7/23/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectView: UICollectionView!
    
    var array : [UserDTO] = []
    var uidKey : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("users").observe(DataEventType.value, with: { (DataSnapshot) in
            self.array.removeAll()
            
            for child in DataSnapshot.children{
                let fchild = child as! DataSnapshot
                let userDTO = UserDTO()
                userDTO.setValuesForKeys(fchild.value as! [String:Any])
                
                self.array.append(userDTO)
            }
            self.collectView.reloadData()
        })
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RowCell", for: indexPath) as! CustomCell
        
        cell.subject.text = array[indexPath.row].subject
        cell.explanation.text = array[indexPath.row].explanation
        
        let data = try? Data(contentsOf: URL(string: array[indexPath.row].imageUrl!)!)
        cell.imageView.image = UIImage(data: data!)
        return cell
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

class CustomCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var explanation: UILabel!
    
    
}
