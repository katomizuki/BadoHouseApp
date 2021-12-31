//
//  AddtionalEventLevelController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/13.
//

import UIKit
import RxSwift
import RxCocoa
protocol AddtionalEventLevelFlow {
    func toNext(image: UIImage,
                dic:[String:Any],
                circle: Circle,
                user: User)
}
class AddtionalEventLevelController: UIViewController {
    private let disposeBag = DisposeBag()
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var maxLabel: UILabel!
    @IBOutlet private weak var maxSlider: UISlider!
    @IBOutlet private weak var minLabel: UILabel!
    @IBOutlet private weak var circleTableView: UITableView!
    @IBOutlet private weak var minSlider: UISlider!
    var viewModel: MakeEventSecondViewModel!
    var coordinator: AddtionalEventLevelFlow?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        minSlider.value = 0.0
        maxSlider.value = 1.0
        setupTableView()
    }
    private func setupTableView() {
        circleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        circleTableView.separatorColor = .darkGray
        circleTableView.allowsMultipleSelection = false
        circleTableView.layer.borderColor = UIColor.lightGray.cgColor
        circleTableView.layer.borderWidth = 1
    }
    private func setupBinding() {
        
        nextButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard let circle = self.viewModel.circle else { return }
            guard let user = self.viewModel.user else { return }
            self.viewModel.dic["minLevel"] = self.viewModel.minLevelText.value
            self.viewModel.dic["maxLevel"] = self.viewModel.maxLevelText.value
            self.coordinator?.toNext(image: self.viewModel.image,
                                     dic: self.viewModel.dic,
                                     circle: circle, user: user)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.minLevelText.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.minLabel.text = "\(text)から"
        }).disposed(by: disposeBag)
        
        viewModel.outputs.maxLevelText.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.maxLabel.text = text
        }).disposed(by: disposeBag)
        
        viewModel.outputs.circleRelay.bind(to: circleTableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { _,item,cell in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = item.name
            cell.selectionStyle = .none
            cell.contentConfiguration = configuration
        }.disposed(by: disposeBag)
        
        circleTableView.rx.itemSelected.asDriver().drive(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            guard let cell = self.circleTableView.cellForRow(at: indexPath) else { return }
            cell.accessoryType = .checkmark
            self.viewModel.circle = self.viewModel.circleRelay.value[indexPath.row]
        }).disposed(by: disposeBag)
        
        circleTableView.rx.itemDeselected.asDriver().drive(onNext: { indexPath in
            guard let cell = self.circleTableView.cellForRow(at: indexPath) else { return }
            cell.accessoryType = .none
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
