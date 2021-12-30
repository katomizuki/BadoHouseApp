//
//  UpdateCircleViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/30.
//

import RxSwift
import RxRelay
import UIKit
protocol UpdateCircleViewModelInputs {
    var nameTextInputs:AnyObserver<String> { get }
    var priceTextInputs:AnyObserver<String> { get }
    var placeTextInputs:AnyObserver<String> { get }
    var dateTextInput:AnyObserver<String> { get }
    var textViewInputs:AnyObserver<String> { get }
    func save()
}
protocol UpdateCircleViewModelOutputs {
    var isError:PublishSubject<Bool>{ get }
}
protocol UpdateCircleViewModelType {
    var inputs: UpdateCircleViewModelInputs { get }
    var outputs: UpdateCircleViewModelOutputs { get }
}
final class UpdateCircleViewModel: UpdateCircleViewModelType, UpdateCircleViewModelInputs, UpdateCircleViewModelOutputs {
    var inputs: UpdateCircleViewModelInputs { return self }
    var outputs: UpdateCircleViewModelOutputs { return self }
    var circleAPI: CircleServiceProtocol
    var circle: Circle
    private var nameTextSubject = PublishSubject<String>()
    private var priceTextSubject = PublishSubject<String>()
    private var placeTextSubject = PublishSubject<String>()
    private var dateTextSubject = PublishSubject<String>()
    private var textViewSubject = PublishSubject<String>()
    var isError = PublishSubject<Bool>()
    var iconImage:UIImage?
    var backgroundImage:UIImage?
    lazy var selectionsFeature = circle.features
    var nameTextInputs: AnyObserver<String> {
        return nameTextSubject.asObserver()
    }
    var priceTextInputs: AnyObserver<String> {
        return priceTextSubject.asObserver()
    }
    var placeTextInputs: AnyObserver<String> {
        return placeTextSubject.asObserver()
    }
    var textViewInputs: AnyObserver<String> {
        return textViewSubject.asObserver()
    }
    var dateTextInput: AnyObserver<String> {
        return dateTextSubject.asObserver()
    }
    private let disposeBag = DisposeBag()
    init(circleAPI: CircleServiceProtocol,circle: Circle) {
        self.circle = circle
        self.circleAPI = circleAPI
        
        nameTextSubject.subscribe(onNext: { [weak self] text in
            self?.circle.name = text
        }).disposed(by: disposeBag)
        
        placeTextSubject.subscribe(onNext: { [weak self] text in
            self?.circle.place = text
        }).disposed(by: disposeBag)
        
        priceTextSubject.subscribe(onNext: { [weak self] text in
            self?.circle.price = text
        }).disposed(by: disposeBag)
        
        dateTextSubject.subscribe(onNext: { [weak self] text in
            self?.circle.time = text
        }).disposed(by: disposeBag)
        
        textViewSubject.subscribe(onNext: { [weak self] text in
            self?.circle.additionlText = text
        }).disposed(by: disposeBag)
    }
    func save() {
        
    }
    func addFeatures(_ feature: CircleFeatures) {
    if !judgeFeatures(feature) {
            selectionsFeature.append(feature.description)
        } else {
            selectionsFeature.remove(value: feature.description)
        }
        circle.features = self.selectionsFeature
    }
    
    func judgeFeatures(_ feature: CircleFeatures) -> Bool {
        return selectionsFeature.contains(feature.description)
    }
}
