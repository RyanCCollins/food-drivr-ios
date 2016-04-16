//
//  User.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/2/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    typealias JsonDict = [String: AnyObject]

    
    dynamic var id: Int = 0
    dynamic var auth_token: String?
    dynamic var name: String?
    dynamic var email: String?
    dynamic var avatar: String?
    dynamic var organisation: String?
    dynamic var phone: String?
    dynamic var role = 0
    dynamic var settings: Setting?
    
    
    convenience init(dict: JsonDict) {
            self.init()
        self.id = dict["id"] as! Int
        self.auth_token = dict["auth_token"] as? String
        self.avatar = dict["avatar"] as? String
        self.email = dict["email"] as? String
        self.name = dict["name"] as? String
        if let org = dict["organization"]?["name"] as? String {
            self.organisation = org
        }
        self.phone = dict["phone"] as? String
        self.role = dict["role_id"] as! Int
        if let settingDict = dict["setting"] as? JsonDict {
            self.settings = Setting(value: settingDict)
        }
    }
}