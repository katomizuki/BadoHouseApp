//
//  AddtionalEventLevelController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/13.
//

import UIKit
import RxSwift
import RxCocoa
class AddtionalEventLevelController: UIViewController {
    private let disposeBag = DisposeBag()
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var maxLabel: UILabel!
    @IBOutlet private weak var maxSlider: UISlider!
    @IBOutlet private weak var minLabel: UILabel!
    @IBOutlet private weak var minSlider: UISlider!
    private let viewModel = MakeEventSecondViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupNavAccessory()
        minSlider.value = 0.0
        maxSlider.value = 1.0
    }
    private func setupBinding() {
        nextButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            let controller = AdditionalEventElementController.init(nibName: "AdditionalEventElementController", bundle: nil)
            self?.navigationController?.pushViewController(controller, animated: true)
        }).disposed(by: disposeBag)
        viewModel.outputs.minLevelText.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.minLabel.text = "\(text)から"
        }).disposed(by: disposeBag)
        viewModel.outputs.maxLevelText.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.maxLabel.text = text
        }).disposed(by: disposeBag)
    }
    // MARK: - IBAction
    @IBAction private func minLevelSliderChanged(_ sender: UISlider) {
        viewModel.inputs.minLevel.onNext(sender.value)
    }
    @IBAction private func maxLevelSliderChanged(_ sender: UISlider) {
        viewModel.inputs.maxLevel.onNext(sender.value)
    }
    @IBAction private func didTapLevelDetailButton(_ sender: Any) {
        let controller = LevelDetailController.init(nibName: "LevelDetailController", bundle: nil)
        present(controller, animated: true)
    }
    
}
