//
//  File.swift
//  Instagram
//
//  Created by tornike dalaqishvili on 7/25/17.
//  Copyright © 2017 tornike dalaqishvili. All rights reserved.
//

import UIKit

struct UserObject {
    var userName: String!
    var img: String!
    var likes: String!
    var views: String!
    
    init(username: String? = "",
         img: String? = "",
         likes: String? = "",
         views: String? = "") {
        self.userName = username
        self.img = img
        self.likes = likes
        self.views = views
    }
}
