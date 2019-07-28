//
//  SignUpViewController.swift
//  Instagram_ios
//
//  Created by Jane Shin on 7/27/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var customSignUpButton: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.backgroundColor = .clear
        usernameTextField.tintColor = .darkGray
        usernameTextField.textColor = .darkGray
        usernameTextField.borderStyle = .none
        
        emailTextField.backgroundColor = .clear
        emailTextField.tintColor = .darkGray
        emailTextField.textColor = .darkGray
        emailTextField.borderStyle = .none
        
        passwordTextField.backgroundColor = .clear
        passwordTextField.tintColor = .darkGray
        passwordTextField.textColor = .darkGray
        passwordTextField.borderStyle = .none
        
        let bottomLayerUsername = CALayer()
        bottomLayerUsername.frame = CGRect(x: 0, y: 20, width: usernameTextField.frame.width, height: 0.6)
        bottomLayerUsername.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        usernameTextField.layer.addSublayer(bottomLayerUsername)
        
        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x: 0, y: 20, width: emailTextField.frame.width, height: 0.6)
        bottomLayerEmail.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        emailTextField.layer.addSublayer(bottomLayerEmail)
        
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 20, width: passwordTextField.frame.width, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        passwordTextField.layer.addSublayer(bottomLayerPassword)

        profileImage.layer.cornerRadius = profileImage.frame.width/2
        profileImage.clipsToBounds = true
        
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        
        handleTextField()
    }
    
    func handleTextField(){
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(){
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            customSignUpButton.backgroundColor = .darkGray
            customSignUpButton.isEnabled = false
            return
        }
        customSignUpButton.backgroundColor = #colorLiteral(red: 0.9849042296, green: 0.7021037936, blue: 0, alpha: 0.6381635274)
        customSignUpButton.setTitleColor(.white, for: UIControl.State.normal)
        customSignUpButton.isEnabled = true
    }
    
    @IBAction func dismiss_onClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, err) in
            
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            
            let uid = Auth.auth().currentUser?.uid
            let image = self.profileImage.image?.jpegData(compressionQuality: 0.1)
            
            let databaseRef = Database.database().reference()
            
            
            let storageRef = Storage.storage().reference()
            let storageProfileRef = storageRef.child("profile-Image").child(uid!)
//            let metadata = StorageMetadata()
//            metadata.contentType = "Image/jpg"
            
            storageProfileRef.putData(image!, metadata: nil, completion: { (storageMetadata, err) in
                if err != nil{
                    return
                }
                storageProfileRef.downloadURL(completion: { (url, err) in
                    let imageUrl = url?.absoluteString
                    let values = ["username": self.usernameTextField.text!, "uid": uid, "email": self.emailTextField.text!, "profileImage": imageUrl]
                    databaseRef.child("users").child(uid!).setValue(values, withCompletionBlock: { (err, ref)  in
                        if err != nil{
                            return
                        }
                        self.performSegue(withIdentifier: "signUpTabBarVC", sender: nil)
                    })
                })
            })
        })
    }
}

extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @objc func handleSelectProfileImageView(){
        let handleSelectProfileImageView = UIImagePickerController()
        handleSelectProfileImageView.delegate = self
        handleSelectProfileImageView.allowsEditing = true
        handleSelectProfileImageView.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(handleSelectProfileImageView, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            selectedImage = image
            profileImage.image = image
        }
        
        dismiss(animated: true, completion: nil)

    }
}
