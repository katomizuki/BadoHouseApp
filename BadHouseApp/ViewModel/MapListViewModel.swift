import RxSwift
import CoreLocation
import Domain

protocol MapListViewModelType {
    var inputs: MapListViewModelInputs { get }
    var outputs: MapListViewModelOutputs { get }
}

protocol MapListViewModelInputs {
    
}
protocol MapListViewModelOutputs {
    
}

final class MapListViewModel: MapListViewModelType, MapListViewModelInputs, MapListViewModelOutputs {
    
    var inputs: any MapListViewModelInputs { self }
    var outputs: any MapListViewModelOutputs { self }
    
    var currnetLatitude: CLLocationDegrees
    var currentLongitude: CLLocationDegrees
    var practices = [Domain.Practice]()
    
    let myData: Domain.UserModel
    
    init(currnetLatitude: CLLocationDegrees,
         currentLongitude: CLLocationDegrees,
         practices: [Domain.Practice],
         myData: Domain.UserModel) {
        self.currnetLatitude = currnetLatitude
        self.currentLongitude = currentLongitude
        self.practices = practices
        self.myData = myData
    }
}
