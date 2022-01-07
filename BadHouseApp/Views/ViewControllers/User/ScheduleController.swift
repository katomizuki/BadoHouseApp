//
//  ScheduleController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/24.
//

import UIKit
import FSCalendar
import RxSwift
import RxCocoa
final class ScheduleController: UIViewController, UIScrollViewDelegate {

    @IBOutlet private weak var calendarView: FSCalendar!
    @IBOutlet private weak var practiceTableView: UITableView!
    private let disposeBag = DisposeBag()
    var viewModel:ScheduleViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        setupBinding()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.willAppear()
    }
    private func setupTableView() {
        practiceTableView.register(SchduleCell.nib(), forCellReuseIdentifier: SchduleCell.id)
        practiceTableView.showsVerticalScrollIndicator = false
        practiceTableView.rowHeight = 60
    }
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapLeftBarButton))
    }
    private func setupBinding() {
        practiceTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.practiceTableView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.outputs.isError.subscribe { [weak self] _ in
            self?.showCDAlert(title: "通信エラーです", message: "", action: "OK", alertType: .warning)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.practiceList.bind(to: practiceTableView.rx.items(cellIdentifier: SchduleCell.id, cellType: SchduleCell.self)) { _, item, cell in
            cell.configure(item)
        }.disposed(by: disposeBag)
        
        practiceTableView.rx.itemSelected.bind { indexPath in
            let controller = PracticeDetailController.init(nibName: R.nib.practiceDetailController.name, bundle: nil)
            controller.viewModel = PracticeDetailViewModel(practice: self.viewModel.practiceList.value[indexPath.row], userAPI: UserService(), circleAPI: CircleService(), isModal: true)
            self.navigationController?.pushViewController(controller, animated: true)
        }.disposed(by: disposeBag)


    }
    @objc private func didTapLeftBarButton() {
        dismiss(animated: true)
    }
}

// MARK: - SchduleCellDelegate
extension ScheduleController: SchduleCellDelegate {
    func onTapTrashButton(_ cell: SchduleCell) {
        print(#function)
    }
}
