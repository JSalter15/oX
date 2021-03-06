//
//  UserManager.swift
//  OnboardingApp
//
//  Created by Josh Broomberg on 2016/05/28.
//  Copyright © 2016 iXperience. All rights reserved.
//

import Foundation

struct User {
    var email: String
    var password: String
}

class UserController {
    // Singleton design pattern
    class var sharedInstance: UserController {
        struct Static {
            static var instance:UserController?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token)    {
            Static.instance = UserController()
        }
        return Static.instance!
    }

    var logged_in_user: User?
    
    // Register a user
    func registerUser(newEmail: String, newPassword: String) -> (failureMessage: String?, user: User?) {
        if let _ = self.getStoredUser(newEmail) {
            return ("Email taken", nil)
        }
        else {}
        
        let user = User(email: newEmail, password: newPassword)
        self.storeUser(user)
        logged_in_user = user
        print("User with email: \(newEmail) has been registered by the UserManager.")
        return (nil, user)
    }
    
    // Store user to hard drive
    func storeUser(user:User) {
        NSUserDefaults.standardUserDefaults().setObject(user.password, forKey: "\(user.email)")
    }
    
    // If user exists, return it
    func getStoredUser(id:String) -> User? {
        if let userPassword:String = NSUserDefaults.standardUserDefaults().stringForKey(id) {
            //user found
            let user = User(email: id, password: userPassword)
            return user
        }
        else {
            //user not found
            return nil
        }
    }
    
    // Login the user if valid
    func loginUser(suppliedEmail: String, suppliedPassword: String) -> (failureMessage: String?, user: User?){
        if let user = self.getStoredUser((suppliedEmail)) {
            if user.password == suppliedPassword {
                logged_in_user = user
                print("User with email: \(suppliedEmail) has been logged in by the UserManager.")
                return (nil, user)
            }
            else {
                return ("Password incorrect", nil)
            }
        }
        return ("No user with that email", nil)
    }
    
    // Logout the user
    func logoutUser() {
        logged_in_user?.email = ""
        logged_in_user?.password = ""
    }
}