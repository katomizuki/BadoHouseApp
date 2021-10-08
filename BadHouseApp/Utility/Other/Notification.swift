import Foundation
import UserNotifications
import UIKit

struct LocalNotification {
    var id: String
    var title: String
    var body: String
}

enum LocalNotificationDurationType {
    case days
    case hours
    case minutes
    case seconds
}

struct LocalNotificationManager {
    static private var notifications = [LocalNotification]()
    static private func requestPermission() -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                }
            }
    }
    
    static private func addNotification(title: String, body: String) -> Void {
        //用意していたnotificationの構造体が入る配列に打ち込む。
        let localNotification = LocalNotification(id: UUID().uuidString, title: title, body: body)
        notifications.append(localNotification)
    }
    
    //スケジュールノーティフィケーションズ
    static private func scheduleNotifications(_ durationInSeconds: Int, repeats: Bool) {
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
            
            if let url = Bundle.main.url(forResource: "logo", withExtension: "png"),
               let attchment = try? UNNotificationAttachment(identifier: "imageId", url: url, options: nil) {
                content.launchImageName = "logo"
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
    
    static private func scheduleNotifications(_ duration: Int, of type: LocalNotificationDurationType, repeats: Bool) {
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
        scheduleNotifications(seconds, repeats: repeats)
    }
    
    static func cancel() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    static func setNotification(_ duration: Int, of type: LocalNotificationDurationType, repeats: Bool, title: String, body: String) {
        requestPermission()
        addNotification(title: title, body: body)
        scheduleNotifications(duration, of: type, repeats: repeats)
    }
}
