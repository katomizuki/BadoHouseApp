import RxSwift
import Firebase

protocol PracticeSearchViewModelType {
    var inputs: PracticeSearchViewModelInputs { get }
    var outputs: PracticeSearchViewModelOutputs { get }
}

protocol PracticeSearchViewModelInputs {
    func changeSelection(_ selection: SearchSelection, text: String)
    func changeFinishPicker(_ date: Date)
    func changeStartPicker(_ date: Date)
    func refresh()
}

protocol PracticeSearchViewModelOutputs {
    var navigationStriing: PublishSubject<String> { get }
    var selectedPlace: String { get }
    var selectedLevel: String { get }
    var reload: PublishSubject<Void> { get }
}

final class PracticeSearchViewModel: PracticeSearchViewModelType,
                                     PracticeSearchViewModelInputs, PracticeSearchViewModelOutputs {
    
    var inputs: PracticeSearchViewModelInputs { return self }
    var outputs: PracticeSearchViewModelOutputs { return self }
    var navigationStriing = PublishSubject<String>()
    var practiceAPI: PracticeRepositry
    var selectedLevel = String()
    var selectedPlace = String()
    var reload = PublishSubject<Void>()
    var practices = [Practice]()
    var fullPractices = [Practice]()
    var searchedPractices = [Practice]()
    
    init(practiceAPI: PracticeRepositry, practices: [Practice]) {
        self.practiceAPI = practiceAPI
        self.practices = practices
        self.fullPractices = practices
    }
    
    func changeSelection(_ selection: SearchSelection, text: String) {
        switch selection {
        case .place:
            self.selectedPlace = text
            self.practices = self.practices.filter { $0.placeName.contains(text) || $0.addressName.contains(text) }
        case .level:
            self.selectedLevel = text
            self.practices = seachLevel(text)
        }
        reload.onNext(())
        navigationStriing.onNext("\(self.practices.count)件のヒット")
    }
    
    func seachLevel(_ text: String) -> [Practice] {
        var array = [Practice]()
        let levelText = text
        var level = Int(levelText.suffix(1))!
        if level == 0 {
            level = 10
        }
        self.practices.forEach { practice in
            var max = Int(practice.maxLevel.suffix(1))!
            if max == 0 {
                max = 10
            }
            var min = Int(practice.minLevel.suffix(1))!
            if min == 0 {
                min = 10
            }
            if min <= level && level <= max {
                array.append(practice)
            }
        }
        return array
    }
    
    func changeStartPicker(_ date: Date) {
        let timeStamp = Timestamp(date: date)
        self.practices = self.practices.filter {
            timeStamp.compare($0.start) == .orderedAscending
        }
        navigationStriing.onNext("\(self.practices.count)件のヒット")
    }
    
    func changeFinishPicker(_ date: Date) {
        let timeStamp = Timestamp(date: date)
        self.practices = self.practices.filter {
            timeStamp.compare($0.start) == .orderedDescending
        }
        navigationStriing.onNext("\(self.practices.count)件のヒット")
    }
    
    func refresh() {
        selectedLevel = String()
        selectedPlace = String()
        practices = fullPractices
        navigationStriing.onNext("\(self.practices.count)件のヒット")
        reload.onNext(())
    }
}
