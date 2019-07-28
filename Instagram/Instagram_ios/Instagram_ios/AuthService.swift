//
//  AuthService.swift
//  Instagram_ios
//
//  Created by Jane Shin on 7/28/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AuthService {
    
    //static - the instance will only be created once
    //ex) AuthService.shared.signIn()
    //static var shared = AuthService()
    
    //static helps class method to perform its taks directly on the class itself
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil{
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        })
    }
    
    static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void){
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in

            if error != nil{
                onError(error!.localizedDescription)
                return
            }

            let uid = Auth.auth().currentUser?.uid

            let storageRef = Storage.storage().reference().child("profile-Image").child(uid!)

            storageRef.putData(imageData, metadata: nil, completion: { (storageMetadata, error) in
                if error != nil{
                    onError(error!.localizedDescription)
                    return
                }
                storageRef.downloadURL(completion: { (url, err) in
                    let profileImageUrl = url?.absoluteString
                    setUserInformation(profileImageUrl: profileImageUrl!, username: username, email: email, password: password, uid: uid!, onSuccess: onSuccess)
                })
            })
        })
    }
    
    static func setUserInformation(profileImageUrl: String, username: String, email: String, password: String, uid: String, onSuccess: @escaping () -> Void) {
        let values = ["username": username, "uid": uid, "email": email, "profileImageUrl": profileImageUrl]
        let databaseRef = Database.database().reference()
        databaseRef.child("users").child(uid).setValue(values)
            onSuccess()
    }
    
}

