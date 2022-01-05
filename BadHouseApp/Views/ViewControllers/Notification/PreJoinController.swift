//
//  PreJoinController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/04.
//

import UIKit
import RxSwift
import RxCocoa

class PreJoinController: UIViewController, UIScrollViewDelegate {
    var viewModel:PreJoinViewModel!
    @IBOutlet private weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PreJoinCell.nib(), forCellReuseIdentifier: PreJoinCell.id)
        tableView.rowHeight = 60
        setupBinding()
    }
    private func setupBinding() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.outputs.preJoinList.bind(to: tableView.rx.items(cellIdentifier: PreJoinCell.id, cellType: PreJoinCell.self)) { _,item,cell in
            cell.configure(item)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.outputs.isError.subscribe { [weak self] _ in
            self?.showCDAlert(title: "通信エラー", message: "", action: "OK", alertType: .warning)
        }.disposed(by: disposeBag)
    }
}