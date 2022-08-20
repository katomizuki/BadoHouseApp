import UIKit
import Firebase
import IQKeyboardManagerSwift
import UserNotifications
import GoogleSignIn
import Network
import ReSwift

let appStore = Store(reducer: appReduce, state: AppState())
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        let signInConfig = GIDConfiguration(clientID: "517884035996-me558ijehkt7r7sjmgt57li9ddvjkq0e.apps.googleusercontent.com")
//        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self)

        setupNotifications(on: application)
        UIApplication.shared.applicationIconBadgeNumber = 0
        Network.shared.setupNetPathMonitor()
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool

          handled = GIDSignIn.sharedInstance.handle(url)
          if handled {
            return true
          }
          return false
    }
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

extension AppDelegate {
    func setupNotifications(on application: UIApplication) {
        //　インスタンス化
        let notificationCenter = UNUserNotificationCenter.current()
        //　delegateを自身に設定。（プッシュ通知のみ必要らしい？）
        //        notificationCenter.delegate = self
        //　許可を求める。
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Failed to request autorization for notification center: \(error.localizedDescription)")
                return
            }
            guard granted else {
                print("Failed to request autorization for notification center: not granted")
                return
            }
            //　許可されたら
            DispatchQueue.main.async {
                //　このアプリにリモート通知を登録する。(できたよ！！とする）→下のdiviceTokenほにゃららに通知される。
                application.registerForRemoteNotifications()
            }
        }
    }
}
//　Mark　UserNotificationDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    //　MarkForeGround
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([ .list, .badge, .sound])
    }
    //　Mark backGround
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer { completionHandler() }
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
    }
}
