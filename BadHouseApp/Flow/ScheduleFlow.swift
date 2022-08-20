//
//  ScheduleFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//
import Domain

protocol ScheduleFlow {
    func toDetail(_ practice: Domain.Practice,
                  myData: Domain.UserModel)
}
