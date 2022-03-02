import RxSwift
import CoreLocation

protocol MapListViewModelType {
    var inputs: MapListViewModelInputs { get }
    var outputs: MapListViewModelOutputs { get }
}

protocol MapListViewModelInputs {
    
}
protocol MapListViewModelOutputs {
    
}

final class MapListViewModel: MapListViewModelType, MapListViewModelInputs, MapListViewModelOutputs {
    
    var inputs: MapListViewModelInputs { return self }
    var outputs: MapListViewModelOutputs { return self }
    
    var currnetLatitude: CLLocationDegrees
    var currentLongitude: CLLocationDegrees
    
    var practices = [Practice]()
    let myData: User
    
    init(currnetLatitude: CLLocationDegrees,
         currentLongitude: CLLocationDegrees,
         practices: [Practice], myData: User) {
        self.currnetLatitude = currnetLatitude
        self.currentLongitude = currentLongitude
        self.practices = practices
        self.myData = myData
    }
}
