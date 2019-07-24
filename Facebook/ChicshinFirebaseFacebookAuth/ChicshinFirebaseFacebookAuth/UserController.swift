//
//  UserController.swift
//  ChicshinFirebaseFacebookAuth
//
//  Created by Jane Shin on 7/23/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase

class UserController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBAction func signout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func profilePhotoUpload(_ sender: Any) {
        
        let imagePick = UIImagePickerController()
        
        imagePick.delegate = self
        imagePick.allowsEditing = true
        imagePick.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(imagePick, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info [UIImagePickerController.InfoKey.originalImage] as! UIImage).pngData()
        let imageName = Auth.auth().currentUser!.uid + "\(Int(NSDate.timeIntervalSinceReferenceDate * 1000)).jpg"
        
        let riversRef = Storage.storage().reference().child("ios_image").child(imageName)
        riversRef.putData(image!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
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
