import Foundation
import UserNotifications
import UIKit

//ローカル通知の構造体を作成
struct LocalNotification {
    var id: String
    var title: String
    var body: String
}

//列挙型でローカル通知が起きるタイミングを設定。
enum LocalNotificationDurationType {
    case days
    case hours
    case minutes
    case seconds
}
//ローカル通知を管理する構造体。
struct LocalNotificationManager {
    //ローカル通知の構造体が入る配列を作成
    static private var notifications = [LocalNotification]()
    //許可のリクエストを送る。
    static private func requestPermission() -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                    //許可されたらここを通る。
                }
        }
    }
    
    static private func addNotification(title: String, body: String) -> Void {
        //用意していたnotificationの構造体が入る配列に打ち込む。
        let localNotification = LocalNotification(id: UUID().uuidString, title: title, body: body)
        notifications.append(localNotification)
    }
    
    //スケジュールノーティフィケーションズ
    static private func scheduleNotifications(_ durationInSeconds: Int, repeats: Bool, userInfo: [AnyHashable : Any]) {
        //アイコンバッジを0にして、
        UIApplication.shared.applicationIconBadgeNumber = 0
        //構造体が入った配列をループさせる。
        for notification in notifications {
            //複数のNotificationをインスタンス化。
            let content = UNMutableNotificationContent()
            //下記で内容を設定.
            content.title = notification.title
            content.body = notification.body
            content.sound = UNNotificationSound.default
            content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
//            content.userInfo = userInfo
            
            if let url = Bundle.main.url(forResource: "logo", withExtension: "png"),
               let attchment = try? UNNotificationAttachment(identifier: "imageId", url: url, options: nil) {
                content.attachments = [attchment]
            }
            
            //度のタイミングでトリガーさせるかを判断する。
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(durationInSeconds), repeats: repeats)
            //リクエストを実際に作成し変数に入れる。
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            //ペンディングされている通知をすべて削除して
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            //ノーティフィケーションセンターにrequestをついかする
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id: \(notification.id)")
            }
        }
        notifications.removeAll()
    }
    
    static private func scheduleNotifications(_ duration: Int, of type: LocalNotificationDurationType, repeats: Bool, userInfo: [AnyHashable : Any]) {
        var seconds = 0
        //typeによって,時間を変更させる。
        switch type {
        case .seconds:
            seconds = duration
        case .minutes:
            seconds = duration * 60
        case .hours:
            seconds = duration * 60 * 60
        case .days:
            seconds = duration * 60 * 60 * 24
        }
        //時間を設定したらいよいよ登録。
        scheduleNotifications(seconds, repeats: repeats, userInfo: userInfo)
    }
    
    static func cancel() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    static func setNotification(_ duration: Int, of type: LocalNotificationDurationType, repeats: Bool, title: String, body: String, userInfo: [AnyHashable : Any]) {
        //許可をリクエストして
        requestPermission()
        //追加して
        addNotification(title: title, body: body)
        //スケジュールを設定する。
        scheduleNotifications(duration, of: type, repeats: repeats, userInfo: userInfo)
    }

}
