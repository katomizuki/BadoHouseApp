//
//  BlockListController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/31.
//

import UIKit
import RxSwift

final class BlockListController: UIViewController, UIScrollViewDelegate {
    private let disposeBag = DisposeBag()
    private let viewModel = BlockListViewModel()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputs.willAppear()
    }
    private func setupBinding() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomCell.nib(), forCellReuseIdentifier: CustomCell.id)
        
        viewModel.outputs.isError.subscribe { [weak self] _ in
            self?.showCDAlert(title: "通信エラーです", message: "", action: "OK", alertType: .warning)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
        
    }
}
extension BlockListController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.blockListRelay.value.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.id, for: indexPath) as? CustomCell else { fatalError() }
        cell.configure(user: viewModel.outputs.blockListRelay.value[indexPath.row])
        return cell
    }
}
extension BlockListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.inputs.removeBlock(viewModel.outputs.blockListRelay.value[indexPath.row])
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "ブロック解除"
    }
}
