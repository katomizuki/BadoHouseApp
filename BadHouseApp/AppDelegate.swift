import UIKit
import Firebase
import IQKeyboardManagerSwift
import UserNotifications
import GoogleSignIn
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate{

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        UNUserNotificationCenter.current().delegate = self
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge], categories: nil))
        

        GIDSignIn.sharedInstance()?.clientID = "517884035996-me558ijehkt7r7sjmgt57li9ddvjkq0e.apps.googleusercontent.com"
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
//        do {
//            try Auth.auth().signOut()
//        } catch {
//
//        }

        return true
    }
    
  

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    //追加
  func application(_ application : UIApplication,open url: URL, sourceApplication: String?, annotation: Any)->Bool{
      return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
  }

    //追加
  func applicationDidBecomeActive(_ application: UIApplication) {
      AppEvents.activateApp()
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

}



