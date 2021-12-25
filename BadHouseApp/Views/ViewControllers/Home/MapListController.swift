//
//  MapListController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/13.
//

import UIKit
protocol MapListFlow:AnyObject {
    
}
final class MapListController: UIViewController {
    var coordinator:MapListFlow?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
