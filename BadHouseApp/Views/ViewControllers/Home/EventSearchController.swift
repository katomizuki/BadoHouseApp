//
//  EventSearchController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/13.
//

import UIKit
import RxSwift
protocol EventSearchFlow:AnyObject {
    
}
protocol EventSearchControllerDelegate:AnyObject {
    func eventSearchControllerDismiss(practices:[Practice], vc:EventSearchController)
}
final class EventSearchController: UIViewController {
    private let disposeBag = DisposeBag()
    var viewModel:PracticeSearchViewModel!
    weak var delegate: EventSearchControllerDelegate?
    @IBOutlet private weak var searchSelectionTableView: UITableView! {
        didSet { searchSelectionTableView.changeCorner(num: 8) }
    }
    @IBOutlet private weak var startPicker:UIDatePicker! {
        didSet {
            startPicker.addTarget(self, action: #selector(changeStartPicker), for: .valueChanged)
        }
    }
    @IBOutlet private weak var finishPicker:UIDatePicker! {
        didSet {
            finishPicker.addTarget(self, action: #selector(changeFinishPicker), for: .valueChanged)
        }
    }
    var coordinator: EventSearchFlow?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        setupBinding()
        navigationItem.title = "\(viewModel.fullPractices.count)件のヒット"
    }
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButton))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearchButton)),UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapReloadButton))]
    }
    @objc private func didTapCloseButton() {
        dismiss(animated: true)
    }
    @objc private func didTapSearchButton() {
        self.delegate?.eventSearchControllerDismiss(practices: viewModel.practices, vc: self)
    }
    @objc private func changeFinishPicker(sender: UIDatePicker) {
        let date = sender.date
        viewModel.inputs.changeFinishPicker(date)
    }
    @objc private func changeStartPicker(sender: UIDatePicker) {
        let date = sender.date
        viewModel.inputs.changeStartPicker(date)
    }
    @objc private func didTapReloadButton() {
        viewModel.inputs.refresh()
    }
    private func setupBinding() {
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.searchSelectionTableView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.outputs.navigationStriing.subscribe(onNext: { [weak self] text in
            self?.navigationItem.title = text
        }).disposed(by: disposeBag)
    }
    private func setupTableView() {
        searchSelectionTableView.delegate = self
        searchSelectionTableView.dataSource = self
        searchSelectionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
}
extension EventSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return }
        if indexPath.row != 2 {
            let viewController = SearchSelectionController()
            viewController.modalPresentationStyle = .popover
            viewController.preferredContentSize = CGSize(width: 200, height: 150)
            viewController.delegate = self
            let presentationController = viewController.popoverPresentationController
            presentationController?.delegate = self
            presentationController?.permittedArrowDirections = .up
            presentationController?.sourceView = cell
            presentationController?.sourceRect = cell.bounds
            viewController.keyWord = SearchSelection(rawValue: indexPath.row) ?? .level
            viewController.presentationController?.delegate = self
            present(viewController, animated: true, completion: nil)
        }
    }
}
extension EventSearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchSelection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = SearchSelection(rawValue: indexPath.row)?.description
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            print(viewModel.outputs.selectedPlace)
            configuration.secondaryText = viewModel.outputs.selectedPlace
        } else if indexPath.row == 1 {
            print(viewModel.outputs.selectedLevel)
            configuration.secondaryText = viewModel.outputs.selectedLevel
        }
        cell.contentConfiguration = configuration
        return cell
    }
    
}
extension EventSearchController:UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
extension EventSearchController: SearchSelectionControllerDelegate {
    func searchSelectionControllerDismiss(vc: SearchSelectionController, selection: SearchSelection, text: String) {
        vc.dismiss(animated: true)
        viewModel.inputs.changeSelection(selection, text: text)
    }
}

