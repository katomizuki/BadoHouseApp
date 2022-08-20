//
//  MyPracticeFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/03/03.
//
import Domain

protocol MyPracticeFlow: AnyObject {
    func toPracticeDetail(myData: Domain.UserModel ,
                          practice: Domain.Practice)
}

