//
//  PreJoinedListController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/04.
//

import UIKit
import RxSwift

final class PreJoinedListController: UIViewController, UIScrollViewDelegate {
    private let disposeBag = DisposeBag()
    @IBOutlet private weak var tableView: UITableView!
    var viewModel:PreJoinedViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        tableView.register(PreJoinedCell.nib(), forCellReuseIdentifier: PreJoinedCell.id)
        tableView.rowHeight = 60
    }
    private func setupBinding() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.outputs.preJoinedList.bind(to: tableView.rx.items(cellIdentifier: PreJoinedCell.id, cellType: PreJoinedCell.self)) { row,item,cell in
            cell.configure()
        }.disposed(by: disposeBag)
        
        viewModel.outputs.isError.subscribe { [weak self] _ in
            self?.showCDAlert(title: "通信エラーです", message: "", action: "OK", alertType: .warning)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
    }
}
