//
//  UploadController.swift
//  ChicshinFirebaseFacebookAuth
//
//  Created by Jane Shin on 7/24/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase

class UploadController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var explanation: UITextField!
    @IBAction func submitButton(_ sender: Any) {
        upload()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.addGestureRecognizer(UITapGestureRecognizer (target: self, action: #selector(openGallery)))
        imageView.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    
    @objc func openGallery() {
        
        let imagePick = UIImagePickerController()
        
        imagePick.delegate = self
        imagePick.allowsEditing = true
        imagePick.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(imagePick, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.imageView.image = info [UIImagePickerController.InfoKey.originalImage] as! UIImage
        dismiss(animated: true, completion: nil)
    }
    
    func upload(){
        let image = (self.imageView.image)!.pngData()
        let imageName = Auth.auth().currentUser!.uid + "\(Int(NSDate.timeIntervalSinceReferenceDate * 1000)).jpg"
        
        let riversRef = Storage.storage().reference().child("ios_image").child(imageName)
        riversRef.putData(image!, metadata: nil) { (metadata, error) in
            if (error != nil) {
                
            } else{

                riversRef.downloadURL { (url, error) in
                    if let downloadURL = url?.absoluteString{
                        Database.database().reference().child("users").childByAutoId().setValue([
                            "userId" : Auth.auth().currentUser?.email,
                            "uid" : Auth.auth().currentUser?.uid,
                            "subject" : self.subject.text!,
                            "explanation" : self.explanation.text!,
                            "imageUrl" : downloadURL
                            ])
                    self.dismiss(animated: true, completion: nil)
                    }
                }
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
