import UIKit
import Firebase
import IQKeyboardManagerSwift
import UserNotifications
import GoogleSignIn
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        GIDSignIn.sharedInstance()?.clientID = "517884035996-me558ijehkt7r7sjmgt57li9ddvjkq0e.apps.googleusercontent.com"
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        setupNotifications(on: application)
        UIApplication.shared.applicationIconBadgeNumber = 0
        
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

extension AppDelegate {
    func setupNotifications(on application: UIApplication) {
        //インスタンス化
        let notificationCenter = UNUserNotificationCenter.current()
        //delegateを自身に設定。（プッシュ通知のみ必要らしい？）
        notificationCenter.delegate = self
        //許可を求める。
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Failed to request autorization for notification center: \(error.localizedDescription)")
                return
            }
            guard granted else {
                print("Failed to request autorization for notification center: not granted")
                return
            }
            //許可されたら
            DispatchQueue.main.async {
                //このアプリにリモート通知を登録する。(できたよ！！とする）→下のdiviceTokenほにゃららに通知される。
                application.registerForRemoteNotifications()
            }
        }
    }
}

extension AppDelegate {
    
    //ここでデバイストークンを受信したあとの処理が走る。
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //通知をうけて,diviceToken（data型）入ってくる。これをサーバーへ送るためには文字列に変換しなければならないのでmap関数を仕様して文字列へと変更してみる。
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        //その配列を一つの文字列にしたいので配列をjoined関数で結合します。
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        //バンドルidを取得して見る。
        let bundleID = Bundle.main.bundleIdentifier
        print("Bundle ID: \(token) \(String(describing: bundleID))")
    }
    
    //デバイストークンの受信に失敗した場合はここの関数が入る。(リモート通知はシミュレーターだと必ず失敗する）
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
}

//Mark:UserNotificationDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
   
    //Mark:ForeGround
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    //Mark backGround
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer { completionHandler() }
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
        let content = response.notification.request.content
        if let userInfo = content.userInfo as? [String: Any],
            let aps = userInfo["aps"] as? [String: Any] {
            print("aps: \(aps)")
        }
    }
}

