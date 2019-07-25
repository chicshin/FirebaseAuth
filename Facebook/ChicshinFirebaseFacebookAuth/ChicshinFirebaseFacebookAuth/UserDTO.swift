//
//  UserDTO.swift
//  ChicshinFirebaseFacebookAuth
//
//  Created by Jane Shin on 7/25/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit

//add objcmembers in order to run the method in objective-c
//otherswise, setvaluesforkeys() in HomeController
//may cause an error

@objcMembers
class UserDTO: NSObject {

    var uid :String?
    var userId :String?
    var subject :String?
    var explanation :String?
    var imageUrl :String?
    var starCount :NSNumber?
    var stars :[String:Bool]?
}
