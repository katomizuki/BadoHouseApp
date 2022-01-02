//
//  MapListViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/02.
//

import RxSwift
import CoreLocation
protocol MapListViewModelType {
    var inputs:MapListViewModelInputs { get }
    var outputs:MapListViewModelOutputs { get }
}
protocol MapListViewModelInputs {
    
}
protocol MapListViewModelOutputs {
    
}

final class MapListViewModel: MapListViewModelType, MapListViewModelInputs, MapListViewModelOutputs {
    var inputs:MapListViewModelInputs { return self }
    var outputs:MapListViewModelOutputs { return self }
    var currnetLatitude:CLLocationDegrees
    var currentLongitude:CLLocationDegrees
    var practices = [Practice]()
    init(currnetLatitude: CLLocationDegrees,
         currentLongitude: CLLocationDegrees,
         practices: [Practice]) {
        self.currnetLatitude = currnetLatitude
        self.currentLongitude = currentLongitude
        self.practices = practices
    }
    
}
