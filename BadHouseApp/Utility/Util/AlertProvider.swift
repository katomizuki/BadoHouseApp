//
//  AlertProvider.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/24.
//

import UIKit
class AlertProvider {
    static func makeAlertVC() -> UIAlertController {
        let alertVC = UIAlertController(title: "このユーザーに関して", message: "", preferredStyle: .actionSheet)
        let problemAction = UIAlertAction(title: "不適切なユーザーである", style: .destructive) {  _ in
        }
        let followAction = UIAlertAction(title: "このユーザーにバド友申請する", style: .default) { _ in
        }
        let canleAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alertVC.addAction(followAction)
        alertVC.addAction(problemAction)
        alertVC.addAction(canleAction)
        return alertVC
    }
    static func postAlertVC()->UIAlertController {
        let alertVC = UIAlertController(title: "この投稿に関して", message: "", preferredStyle: .actionSheet)
        let problemAction = UIAlertAction(title: "不適切な投稿である", style: .destructive) {  _ in
        }
        let followAction = UIAlertAction(title: "この練習に参加申請をする", style: .default) { _ in
        }
        
        let canleAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alertVC.addAction(followAction)
        alertVC.addAction(problemAction)
        alertVC.addAction(canleAction)
        return alertVC
    }
}
