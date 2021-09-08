//
//  CommentViewController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/09/08.
//

import UIKit

class CommentViewController: UIViewController {
    
    var introduction = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        label.numberOfLines = 0
        label.text = introduction
        view.addSubview(label)
        label.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 150, height:80)
        view.backgroundColor = .systemGray3
    }
    

   

}
