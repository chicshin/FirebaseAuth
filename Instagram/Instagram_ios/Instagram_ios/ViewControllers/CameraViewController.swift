//
//  CameraViewController.swift
//  Instagram_ios
//
//  Created by Jane Shin on 7/27/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class CameraViewController: UIViewController {

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        photo.isUserInteractionEnabled = true
        photo.clipsToBounds = true
        
        postButton.backgroundColor = #colorLiteral(red: 0.9849042296, green: 0.7021037936, blue: 0, alpha: 0.6381635274)
        postButton.setTitleColor(.white, for: UIControl.State.normal)
        postButton.layer.cornerRadius = postButton.frame.width/30
        postButton.isEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
        
    }
    
    func handlePost(){
        if selectedImage != nil{
            postButton.setTitleColor(.white, for: UIControl.State.normal)
            postButton.backgroundColor = #colorLiteral(red: 0.9849042296, green: 0.7021037936, blue: 0, alpha: 0.6381635274)
            postButton.isEnabled = true
        }else{
            postButton.isEnabled = false
            postButton.backgroundColor = .clear
        }
    }
    
    func sendDataToDatabase(photoUrl: String){
        let postsRef = Database.database().reference().child("posts")
        let newPostId = postsRef.childByAutoId().key
        postsRef.child(newPostId!).setValue(["photoUrl": photoUrl, "captionTextView": captionTextView.text!], withCompletionBlock: { (error, ref) in
            if error != nil{
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("Completed")
            self.captionTextView.text! = ""
            self.photo.image = UIImage(named: "placeholder-photo")
            self.selectedImage = nil
            self.tabBarController?.selectedIndex = 0
        })
    }
    
    @IBAction func postButton_touchUpInside(_ sender: Any) {
        ProgressHUD.show("Uploading...", interaction: false)
        
        if selectedImage != nil{
            let imageData = self.photo.image?.jpegData(compressionQuality: 0.1)
            let photoIdString = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("posts").child(photoIdString)
            storageRef.putData(imageData!, metadata: nil, completion: { (storageMetadata, error) in
                if error != nil{
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                storageRef.downloadURL(completion: { (url, error) in
                    let photoUrl = url?.absoluteString
                    self.sendDataToDatabase(photoUrl: photoUrl!)
                })
            })
        }else{
            ProgressHUD.showError("Image can't be empty")
        }
    }
    
}

extension CameraViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    @objc func handleSelectPhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            selectedImage = image
            photo.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
