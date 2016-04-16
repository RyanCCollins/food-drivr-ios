//
//  UserRouter.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/2/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import Alamofire

enum UserEndpoint {
    case Login(username: String , password: String)
    case Register(userData: UserRegistration)
}

class UserRouter : BaseRouter {
    
    var endpoint: UserEndpoint
    init(endpoint: UserEndpoint) {
        self.endpoint = endpoint
    }
    
    override var method: Alamofire.Method {
        switch endpoint {
        case .Login: return .POST
        case .Register: return .POST
        }
    }
    
    override var path: String {
        switch endpoint {
        case .Login: return "user/login"
        case .Register: return "users"
        }
    }
    
    override var parameters: APIParams {
        switch endpoint {
        case .Login(let username, let password):
            var response = [String: AnyObject]()
            response["username"] = username
            response["password"] = password
            return response
        case .Register(let userData):
            do {
                let user = try userData.toJSON()
                return ["user": user]
            } catch {
                return [:]
            }
        }
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        switch endpoint {
        case .Login: return .URL
        case .Register: return .URL
        }
    }
    
}