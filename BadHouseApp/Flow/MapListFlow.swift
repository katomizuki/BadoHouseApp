//
//  MapListFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//
import Domain

protocol MapListFlow: AnyObject {
    func halfModal(_ practice: Domain.Practice,
                   _ vc: MapListController,
                   myData: Domain.UserModel)
}
