//
//  AppDelegate.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 3/28/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import TwitterKit
import Fabric
import SlideMenuControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UITabBar.appearance().barTintColor = UIColor.whiteColor()
        UITabBar.appearance().tintColor = UIColor(red: 20/255, green: 207/255, blue: 232/255, alpha: 1)
        UITabBar.appearance().backgroundImage = UIImage(named: "tabbarback")
        setupFacebookAndTwitter()
        runLoginFlow()
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        registerForPushNotifications(application)
    }
    
    func runLoginFlow() -> Void {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let user = AuthService.sharedInstance.getCurrentUser() {
            // Code to execute if user is logged in
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            switch user.userRole {
            case .Donor :
                let setViewController = mainStoryboard.instantiateViewControllerWithIdentifier("DonorTabMenu")
                self.window?.rootViewController = setViewController
                break
            case .Driver :
                let setViewController = mainStoryboard.instantiateViewControllerWithIdentifier("DriverTabMenu")
                self.window?.rootViewController = setViewController
                break
            }
            
            
            
        } else {
            AuthService.sharedInstance.destroyToken()
            let loginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.window?.rootViewController = loginViewController
        }
            self.window?.makeKeyAndVisible()
    }

    private func setupFacebookAndTwitter() -> Bool {
        
        // Mark - loading the ApiKeys.plist file
        guard let filePath = NSBundle.mainBundle().pathForResource("ApiKeys", ofType: "plist") else {
            return false
        }
        // Mark - insert to in dictionary
        guard let dictionary = NSDictionary(contentsOfFile:filePath) else {
            return false
        }
        
        // Mark - configure Facebook
        guard let facebookAppId = dictionary["FACEBOOK_API_APP_ID"] as? String ,
            let facebookDisplayName = dictionary["FACEBOOK_API_DIPLAY_NAME"] as? String ,
            let appURLSchemeSuffix = dictionary["FACEBOOK_API_URL_SCHEME_SUFFIX"] as? String    else {
                return false
        }
        
        FBSDKSettings.setAppID(facebookAppId)
        FBSDKSettings.setDisplayName(facebookDisplayName)
        FBSDKSettings.setAppURLSchemeSuffix(appURLSchemeSuffix)
        
        //Mark - configure Twitter
        guard let twitterAppKey = dictionary["TWITTER_API_APP_KEY"] as? String ,
            let twitterConsumerSecret = dictionary["TWITTER_API_CONSUMER_SECRET"] as? String else {
                return true
        }
        Twitter.sharedInstance().startWithConsumerKey(twitterAppKey, consumerSecret: twitterConsumerSecret)
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        let aps = userInfo["aps"] as! [String: AnyObject]
        /* Check for new events when they are sent */
        if (aps["new-event"] as? NSString)?.integerValue == 1 {
            print("Notification received for new event")
            /* Logic for handling this has been removed for submission because I would need to setup a provisioning profile for the reviewer. */
        }
    }
    
    /** Save the user's device token to user defaults to be used later.
     */
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
        /* Logic for handling this has been removed for submission because I would need to setup a provisioning profile for the reviewer. */
    }


}

