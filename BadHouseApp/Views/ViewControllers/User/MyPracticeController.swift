//
//  MyPracticeController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/31.
//

import UIKit
import RxSwift
import RxCocoa
final class MyPracticeController: UIViewController, UIScrollViewDelegate {

    @IBOutlet private weak var tableView: UITableView!
    var viewModel:MyPracticeViewModel!
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    private func setupBinding() {
        
        tableView.register(CustomCell.nib(), forCellReuseIdentifier: CustomCell.id)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.outputs.practices.bind(to: tableView.rx.items(cellIdentifier: CustomCell.id, cellType: CustomCell.self)) { _, item, cell in
            cell.configure(practice: item)
        }.disposed(by: disposeBag)
        
        tableView.rx.itemDeleted.bind(onNext: {[weak self] indexPath in
            let alertVC = AlertProvider.practiceAlertVC()
            guard let self = self else { return }
            let gatherAction = UIAlertAction(title: "この練習の募集を停止する", style: .destructive) {  _ in
                self.viewModel.inputs.deletePractice(self.viewModel.practices.value[indexPath.row])
            }
            alertVC.addAction(gatherAction)
            self.present(alertVC, animated: true)
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            let viewModel = PracticeDetailViewModel(practice: self.viewModel.practices.value[indexPath.row],
                                                    userAPI: UserService(),
                                                    circleAPI: CircleService())
            let controller = PracticeDetailController.init(nibName: R.nib.practiceDetailController.name, bundle: nil)
            controller.viewModel = viewModel
            self.navigationController?.pushViewController(controller, animated: true)
        }).disposed(by: disposeBag)
    }
}

