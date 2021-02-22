//
//  AppDelegate.swift
//  Collimate
//
//  Created by Zesheng Xing on 2/18/21.
//

import UIKit
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    // MARK: Google Sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            // TODO: warn user login failed due to some error
            return
        }
        
        guard let email = user.profile.email, let name = user.profile.name else {
            return
        }
        
        // check if it's UCD email, if not, send notification and return
        // TODO: refactor this
        if !email.hasSuffix("@ucdavis.edu") {
            // TODO: warn user login email is invalid
            NotificationCenter.default.post(name: Notification.Name("invalidEmail"), object: nil)
            return
        }
        
        // if new user, insert user into firestore
        let firestore = DatabaseFactory.generateDatabase("firestore")
        
        firestore.doesUserExists(email) { doesExist in
            if !doesExist! {
                firestore.createUser(with: User.createUserInstance(email, name))
            }
        }
        
        // get credential to sign in
        guard let authentication = user.authentication else {
            // TODO: warn user if there is an error with credential
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        // sign in
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResultt, error in
            // if failed to sign in, return
            guard authResultt != nil, error == nil else {
                // TODO: warn user if there is an error with login
                return
            }
            
            // post a notification to inform that the user has signed in
            // TODO: refactor this
            NotificationCenter.default.post(name: Notification.Name("googleLogin"), object: nil)
        })

        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // TODO: handle logic to deal with user disconnect
    }
    
}

