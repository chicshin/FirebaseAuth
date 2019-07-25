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
        
        //To speed up for image loading process
        //use observeSingleEvent(), run first-time
        //instead of observe()
        Database.database().reference().child("users").observeSingleEvent(of: DataEventType.value, with: { (DataSnapshot) in
            self.array.removeAll()
            self.uidKey.removeAll()
            
            for child in DataSnapshot.children{
                let fchild = child as! DataSnapshot
                let userDTO = UserDTO()
                let uidKey = fchild.key
                userDTO.setValuesForKeys(fchild.value as! [String:Any])
                
                self.array.append(userDTO)
                self.uidKey.append(uidKey)
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
        
        cell.starButton.tag = indexPath.row
        cell.starButton.addTarget(self, action: #selector(like(_:)), for: .touchUpInside)
        
        if let _ = self.array[indexPath.row].stars?[(Auth.auth().currentUser?.uid)!] {
            cell.starButton.setImage(#imageLiteral(resourceName: "baseline_favorite_black_24pt"), for: .normal)
        }else{
            cell.starButton.setImage(#imageLiteral(resourceName: "baseline_favorite_border_black_24pt"), for: .normal)
        }
        return cell
    }
    
    @objc func like(_ sender :UIButton) {
        
        if(sender.currentImage == #imageLiteral(resourceName: "baseline_favorite_black_24pt")){
            sender.setImage(#imageLiteral(resourceName: "baseline_favorite_border_black_24pt"), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "baseline_favorite_black_24pt"), for: .normal)
        }
        Database.database().reference().child("users").child(self.uidKey[sender.tag]).runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                var stars: Dictionary<String, Bool>
                stars = post["stars"] as? [String : Bool] ?? [:]
                var starCount = post["starCount"] as? Int ?? 0
                if let _ = stars[uid] {
                    // Unstar the post and remove self from stars
                    starCount -= 1
                    stars.removeValue(forKey: uid)
                } else {
                    // Star the post and add self to stars
                    starCount += 1
                    stars[uid] = true
                }
                post["starCount"] = starCount as AnyObject?
                post["stars"] = stars as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
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
    
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var explanation: UILabel!
    
    
}
