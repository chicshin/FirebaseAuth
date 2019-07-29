//
//  Post.swift
//  Instagram_ios
//
//  Created by Jane Shin on 7/29/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import Foundation
class Post {
    var captionTextView: String
    var photoUrl: String
    
    init(captionText: String, photoUrlString: String) {
        captionTextView = captionText
        photoUrl = photoUrlString
    }
}
